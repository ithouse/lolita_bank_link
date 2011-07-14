module Lolita::BankLink
  class Response
    attr_reader :params, :required_params, :error, :crypt

    def initialize params
      @params = self.read_required_params(params)
      @crypt = Lolita::BankLink::Crypt.new
    end

    def required_params_by_service(service)
      required_fields = nil
      if service=='1002'
        required_fields = [:service,:version,:snd_id,:stamp,:amount,:curr,:ref,:msg]
      elsif service=='1101'
        required_fields = [:service,:version,:snd_id,:rec_id,:stamp,:t_no,:amount,:curr,:rec_acc,:rec_name,:snd_acc,:snd_name,:ref,:msg,:t_date]
      elsif service=='1901'
        required_fields = [:service,:version,:snd_id,:rec_id,:stamp,:ref,:msg]
      end
      required_fields
    end

    def get_trx_id
      self.required_params[:ref]
    end

    def update_transaction
      get_trx.update_attribute(:status, completed? ? :completed : :rejected)
    end

    def completed?
      self.params[:service].to_i == 1101
    end

    def failed?
      !completed?
    end

    def valid?
      if self.params[:service].to_i == 1902
        self.error = "Comunication error, sender or signature  not recognized"
      elsif self.params[:rec_id] != Lolita::BankLink.sender
        self.error = "Wrong sender"
      elsif !self.crypt.verify_mac_signature(self.params,read_signature)
        self.error = "Wrong signature"
      end
      self.error ? false : true
    end

    private

    def get_trx
      Lolita::BankLink::Transaction.find(self.get_trx_id)
    end

    def read_signature
      self.params['VK_MAC']
    end

    def read_required_params(param_hash)
      req_params = {}
      if param_hash['VK_SERVICE'].nil?
        self.error = "BankLinkGateway reading post service not set"
      else
        req_list = required_params_by_service(param_hash['VK_SERVICE'])
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