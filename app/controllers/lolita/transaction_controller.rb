module Lolita::BankLink
  class TransactionController < Lolita::BankLink::CommonController
    before_filter :is_ssl_required
    before_filter :check_valid_payment
    layout false

    def checkout
      @payment_request = Lolita::BankLink::Request.new(@payment)
      render "lolita/bank_link/payment_form"
    end

    # there we land after returning from BankLink server
    # then we get transactions result and redirect to your given "finish" path
    def answer
      #@test_parameters = {"encoding"=>"WINDOWS-1257", "VK_REC_ID"=>"SMSBUZZ", "VK_REF"=>"1", "VK_STAMP"=>"1", "VK_SERVICE"=>"1901", "action"=>"confirm", "VK_MSG"=>"Pirkums smsbuzz.lv", "VK_LANG"=>"LAT", "controller"=>"cms/swedbank_banklink", "VK_VERSION"=>"008", "VK_AUTO"=>"N", "VK_MAC"=>"YqK6ddIUcRdoU+pwciixtweaoAvPU3uqYnSPYoC2nxnLUfWDYRpFbhVr1ZOFOugTilxb8l9di1ihA3uie4tasPUX3ID8nXOTrmb8B/XMtOIvxlEVe8SGemmA+cn6Y12bknOcckhw602jDo3OkceKMsv1QWlYFedkoEHOftLZaHc=", "VK_SND_ID"=>"HP"}
      #@test_parameters = {"encoding"=>"WINDOWS-1257", "VK_REC_ID"=>"SMSBUZZ", "VK_REF"=>"2", "VK_STAMP"=>"2", "VK_SERVICE"=>"1901", "action"=>"confirm", "VK_MSG"=>"Pirkums smsbuzz.lv", "VK_LANG"=>"LAT", "controller"=>"cms/swedbank_banklink", "VK_VERSION"=>"008", "VK_AUTO"=>"N", "VK_MAC"=>"HUSXJzvBZV3CKuULkeq1ht9VNx8im29wfKDW5ReoyKQPkL6iy9JDzlT5w9sHugWQk9pf2F76+EPqsKIDN0JMjJEZSu9lgpSnkCvlZQTRMvavKwfOg6YotY0EQ4RPTGu2e7e8U7eqz+VS9ng/g/tgYNl/AqMevQikHHnhzwAdnsg=", "VK_SND_ID"=>"HP"}

      rs = Lolita::BankLink::Response.new(params)
      if rs.valid?
        rs.update_transaction
        redirect_to "#{session[:payment_data][:finish_path]}?merchant=bank_link&trx_id=#{rs.get_trx_id}"
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