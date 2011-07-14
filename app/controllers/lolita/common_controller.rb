module Lolita::BankLink
  class CommonController < ActionController::Base
    before_filter :set_active_payment
    skip_before_filter :verify_authenticity_token

    private

    # returns current payment instance from session
    def set_active_payment
      if session && session[:payment_data] && params[:controller] == 'Lolita::BankLink::Transaction'
        @payment ||= session[:payment_data][:billing_class].constantize.find(session[:payment_data][:billing_id])
      end
    end
    
  end
end
