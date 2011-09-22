module Lolita::BankLink
  module Billing
    def self.included(base)
      base.has_many :bank_link_transactions, :as => :paymentable, :class_name => "Lolita::BankLink::Transaction", :dependent => :destroy
      base.class_eval do

        def bank_link_paid?
          return true if self.bank_link_transactions.count(:conditions => {:status => 'completed'}) >= 1
        end

        def log severity, message
          raise "Redefine this method in your billing model."
        end

        def bank_link_trx_saved trx
          raise "Redefine this method in your billing model."
        end  

      end
    end
  end
end
