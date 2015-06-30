module LolitaBankLink
  class TransactionsController < LolitaBankLink::ApplicationController
    before_filter :is_ssl_required
    before_filter :set_active_payment, :check_valid_payment, only: :checkout

    def checkout
      transaction = LolitaBankLink::Transaction.add(@payment, request)
      @payment_request = LolitaBankLink::Request.new(@payment, transaction)
      render "lolita_bank_link/payment_form"
    ensure
      if @payment && @payment_request
        LolitaBankLink.logger.info("[#{session_id}][#{@payment.id}][checkout] #{@payment_request.build_form_data}")
      end
    end

    # This action is called twice
    #   - after client returns from BankLink server
    #   - bank sends another confirmation and add's VK_AUTO=Y to params
    def answer
      response = LolitaBankLink::Response.new(response_params)
      if response.update_transaction
        if bank_auto_response?
          render nothing: true
        else
          redirect_to response.return_path
        end
      else
        if !bank_auto_response? && response.transaction_completed?
          redirect_to response.return_path
        else
          LolitaBankLink.logger.error("[#{session_id}][#{response.paymentable_id}][answer] #{response.error}")
          render text: I18n.t("bank_link.wrong_request"), status: 400
        end
      end
    ensure
      if response
        LolitaBankLink.logger.info("[#{session_id}][#{response.paymentable_id}][answer] #{response.params}")
      end
    end

    private

    def bank_auto_response?
      params["VK_AUTO"] == "Y"
    end

    # returns current payment instance from session
    def set_active_payment
      if session && session[:payment_data]
        @payment ||= session[:payment_data][:billing_class].constantize.find(session[:payment_data][:billing_id])
      end
    end

    # payment should not be paid
    def check_valid_payment
      if @payment && @payment.paid?
        render text: I18n.t("bank_link.wrong_request"), status: 400
      end
    end

    # forces SSL in production mode if available
    def is_ssl_required
      ssl_required(:answer, :checkout) if defined?(ssl_required)
    end

    def response_params
      params.permit("VK_T_NO",
                    "VK_SND_NAME",
                    "VK_REF",
                    "VK_REC_ID",
                    "VK_SND_ACC",
                    "VK_STAMP",
                    "VK_T_DATE",
                    "VK_AMOUNT",
                    "VK_REC_NAME",
                    "VK_SERVICE",
                    "VK_LANG",
                    "VK_AUTO",
                    "VK_MSG",
                    "VK_ENCODING",
                    "VK_VERSION",
                    "VK_SND_ID",
                    "VK_CURR",
                    "VK_REC_ACC",
                    "VK_MAC")
    end

    def session_id
      request.session_options[:id]
    end
  end

end
