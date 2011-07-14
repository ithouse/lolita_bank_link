module Lolita::BankLink
  class TestController < Lolita::BankLink::CommonController
    before_filter :render_nothing
    
    # you get there if you are in development environment and access "checkout" action, it's for testing server responses
    def fake_server
      @@return_host = request.env["HTTP_REFERER"].split('/')[2] if request.env["HTTP_REFERER"]
      if params[:command]
        server_handler
      else
        client_handler
      end
    end

    # when "success" button pressed
    def fake_success
      @@fake_result = true
      redirect_to answer_bank_link_url(:host => @@return_host, :trans_id => session[:fake_server][:trans_id])
    end

    # when "failure" button pressed
    def fake_failure
      @@fake_result = false
      redirect_to answer_bank_link_url(:host => @@return_host, :trans_id => session[:fake_server][:trans_id])
    end

    # renders nothing if not in development environment
    def render_nothing
      render :nothing => true if RAILS_ENV == 'production'
    end

  end
end
