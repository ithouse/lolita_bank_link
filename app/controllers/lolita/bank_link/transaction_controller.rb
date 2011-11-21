module Lolita::BankLink
  class TransactionController < Lolita::BankLink::CommonController
    before_filter :is_ssl_required
    before_filter :check_valid_payment, :only => :checkout
    layout false

    def checkout
      transaction = Lolita::BankLink::Transaction.add(@payment, request)
      @payment_request = Lolita::BankLink::Request.new(@payment, transaction)
      render "lolita/bank_link/payment_form"
    end

    # there we land after returning from BankLink server
    # then we get transactions result and redirect to your given "finish" path
    def answer
      rs = Lolita::BankLink::Response.new(params)
      if rs.valid? && rs.update_transaction
        if session[:payment_data] && session[:payment_data][:finish_path]
          redirect_to "#{session[:payment_data][:finish_path]}?merchant=bank_link"
          return
        elsif trx = rs.get_trx
          if trx.paymentable.respond_to?('finish_payments_path')
            session[:payment_data] ||= {}
            session[:payment_data][:billing_class] = trx.paymentable.class.to_s
            session[:payment_data][:billing_id]    = trx.paymentable.id
            
            redirect_to "#{trx.paymentable.finish_payments_path}?merchant=bank_link#{params[:VK_AUTO] == "Y" ? '&server_confirm=1' : ''}"
            return
          end
        end
        render :nothing => true 
      else
        render :text => I18n.t('bank_link.wrong_request'), :status => 400
      end  
    end

    private

    def check_valid_payment
      render(:text => I18n.t('bank_link.wrong_request'), :status => 400) unless @payment && !@payment.paid?
    end

    # forces SSL in production mode if available
    def is_ssl_required
      ssl_required(:answer, :checkout) if defined?(ssl_required) && (RAILS_ENV == 'production' || RAILS_ENV == 'staging')
    end
  end
end
