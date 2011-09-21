module Lolita
  module BankLink
    mattr_accessor :bank_certificate, :private_key, :sender, :url, :lang
  
    BANK_LINK_PRIVATE_KEY = "../../../spec/fixtures/private_key.pem"
    BANK_LINK_BANK_CERTIFICATE = "../../../spec/fixtures/certificate.pem"
    BANK_LINK_SENDER = "TEST"

    # defaults
    self.private_key = BANK_LINK_PRIVATE_KEY
    self.bank_certificate = BANK_LINK_BANK_CERTIFICATE
    self.sender = BANK_LINK_SENDER
    self.url = "https://ib.swedbank.lv/banklink"
    self.lang = "LAT"

    class<<self

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

      def debug?
        ActiveMerchant::Billing::Base.mode == :debug
      end

      def action_url
        debug? ? debug_domain : url
      end
      
      def debug_domain
        "http://127.0.0.1:3001/bank_link_test/fake_server/?"
      end

    end
  end
end
