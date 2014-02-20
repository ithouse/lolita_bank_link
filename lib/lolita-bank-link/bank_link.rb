module LolitaBankLink
  class << self
    def private_key
      ENV["BANK_LINK_PRIVATE_KEY"]
    end

    def bank_certificate
      ENV["BANK_LINK_CERTIFICATE"]
    end

    def sender
      ENV["BANK_LINK_SENDER"]
    end

    def url
      ENV["BANK_LINK_URL"]
    end

    def lang
      ENV["BANK_LINK_LANG"]
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

  end
end
