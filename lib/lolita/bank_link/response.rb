module Lolita::BankLink
  class Response
    attr_reader :params, :required_params, :crypt, :signature
    attr_accessor :error

    def initialize params
      @params = read_required_params(params)
      @signature = read_signature(params)
      @crypt = Lolita::BankLink::Crypt.new
    end

    def get_trx_id
      self.params.has_key?(:ref) ? self.params[:ref] : nil
    end

    def update_transaction
      trx = get_trx
      trx.update_attribute(:status, completed? ? 'completed' : 'rejected') if trx
      trx.update_attributes(@params)
      trx
    end

    def completed?
      self.params[:service].to_i == 1101
    end

    def failed?
      !completed?
    end

    def valid?
      if self.params[:rec_id] != Lolita::BankLink.sender
        self.error = "Wrong sender"
      elsif !self.crypt.verify_mac_signature(self.params,self.signature)
        self.error = "Wrong signature"
      end
      self.error ? false : true
    end

    def get_trx
      self.get_trx_id ? Lolita::BankLink::Transaction.find_by_id(self.get_trx_id) : nil
    end

    private

    def read_signature(params)
      params['VK_MAC'].blank? ? "" : params['VK_MAC']
    end

    def read_required_params(param_hash)
      req_params = {}
      if param_hash['VK_SERVICE'].nil?
        self.error = "BankLinkGateway reading post service not set"
      else
        req_list = Lolita::BankLink.required_params_by_service(param_hash['VK_SERVICE'])
        if req_list.nil?
          self.error = "BankLinkGateway unknown service posted #{param_hash['VK_SERVICE']}"
        else
          req_list.each{|item|
            value = param_hash['VK_'+item.to_s.upcase]
            if value.nil?
              self.error = "BankLinkGateway a required param #{'VK_'+item.to_s.upcase} from post for signature check is not available for service: #{param_hash['VK_SERVICE']}"
            else
              req_params[item] = value.to_s
            end
          }
        end
      end
      req_params
    end

  end
end
