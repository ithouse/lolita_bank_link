module Lolita::BankLink
  class TestController < Lolita::BankLink::CommonController
    before_filter :render_nothing
    
    # you get there if you are in development environment and access "checkout" action, it's for testing server responses
    def fake_server
      @@return_host = request.env["HTTP_REFERER"].split('/')[2] if request.env["HTTP_REFERER"]
      if params["VK_SERVICE"]
        server_handler
      else
        client_handler
      end
    end

    # when "success" button pressed
    def fake_success
      @@fake_result = true
      data = complete_bank_link_repsponse(session[:fake_server][:params], '1101')
      redirect_to answer_bank_link_url(data.merge(:host => @@return_host))
    end

    # when "failure" button pressed
    def fake_failure
      @@fake_result = false
      data = complete_bank_link_repsponse(session[:fake_server][:params], '1901')
      redirect_to answer_bank_link_url(data.merge(:host => @@return_host))
    end

    # renders nothing if not in development environment
    def render_nothing
      render :nothing => true if RAILS_ENV == 'production'
    end

    private

    # acts as server handler
    def server_handler
      data = read_required_params(params)
      session[:fake_server] ||= {}
      session[:fake_server][:params] = data
    end
    
    def client_handler
    end

    def read_required_params(param_hash)
      req_params = {}
      req_list = Lolita::BankLink.required_params_by_service(param_hash['VK_SERVICE'])
      req_list.each{|item|
        value = param_hash['VK_'+item.to_s.upcase]
        req_params[item] = value.to_s
      }
      req_params
    end
    def complete_bank_link_repsponse(param_hash, service = '1101')
      if service == '1101'
        param_hash[:service] = '1101'
        param_hash[:rec_id] = param_hash[:snd_id]
        param_hash[:snd_id] = 'HP'
        param_hash[:t_no] = '101'
        param_hash[:rec_acc] = "LV12HABA0000000000000"
        param_hash[:rec_name] = "ITH GROUP SIA"
        param_hash[:snd_acc] = "LV12HABA0000000000000"
        param_hash[:snd_name] = "JĀNIS ĀĶĪTIS"
        param_hash[:t_date] = Time.now.strftime("%d.%m.%Y")
      elsif service == '1901'
        param_hash.delete(:amount)
        param_hash.delete(:curr)
        param_hash[:service] = '1901'
        param_hash[:rec_id] = param_hash[:snd_id]
        param_hash[:snd_id] = 'HP'
      else
        param_hash = {:service => ''}
      end
      data = {}
      param_hash.each {|key, val|
        data['VK_'+key.to_s.upcase] = val
      }
      rs = Lolita::BankLink::Response.new(data)
      data["VK_MAC"] = rs.crypt.calc_mac_signature(rs.params, param_hash[:service])
      #RAILS_DEFAULT_LOGGER.info "complete_bank_link_repsponse=#{data}"
      data
    end

  end
end
