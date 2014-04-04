module LolitaBankLink
  class Response
    attr_reader :params, :required_params, :crypt, :signature
    attr_accessor :error

    def initialize params
      @params = read_required_params(params)
      @signature = read_signature(params)
      @crypt = LolitaBankLink::Crypt.new
    end

    def update_transaction
      if valid?
        new_status = completed? ? "completed" : "failed"
        transaction.update_attributes!(params.merge(status: new_status))
      end
    end

    def completed?
      self.params[:service].to_i == 1101
    end

    def valid?
      if self.params[:rec_id] != LolitaBankLink.sender
        self.error = "Wrong sender" and return false
      elsif !self.crypt.verify_mac_signature(self.params,self.signature)
        self.error = "Wrong signature" and return false
      elsif transaction.status.to_sym != :processing
        self.error = "Transaction has wrong status: #{transaction.status}"
      end
      self.error.blank?
    end

    def transaction
      @trx ||= LolitaBankLink::Transaction.where(id: params[:ref]).first
    end

    def return_path
      transaction.paymentable.bank_link_return_path
    end

    def paymentable_id
      transaction && transaction.paymentable_id
    end

    private

    def read_signature(params)
      params["VK_MAC"].blank? ? "" : params["VK_MAC"]
    end

    def read_required_params(param_hash)
      req_params = {}
      if param_hash["VK_SERVICE"].nil?
        self.error = "BankLinkGateway reading post service not set"
      else
        req_list = LolitaBankLink.required_params_by_service(param_hash["VK_SERVICE"])
        if req_list.nil?
          self.error = "BankLinkGateway unknown service posted #{param_hash["VK_SERVICE"]}"
        else
          req_list.each{|item|
            value = param_hash["VK_"+item.to_s.upcase]
            if value.nil?
              self.error = "BankLinkGateway a required param #{"VK_"+item.to_s.upcase} from post for signature check is not available for service: #{param_hash["VK_SERVICE"]}"
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
