module LolitaBankLink
  module Billing
    def self.included(base)
      base.has_many :bank_link_transactions, as: :paymentable, class_name: "LolitaBankLink::Transaction", dependent: :destroy
      base.class_eval do

        # Payment description
        def description
          raise 'Redefine this method in your billing model.'
        end

        # Price of payment in cents
        def price
          raise 'Redefine this method in your billing model.'
        end

        # Currency as 3 letter code as in ISO 4217
        def currency
          raise 'Redefine this method in your billing model.'
        end

        def bank_link_trx_saved trx
          raise "Redefine this method in your billing model."
        end

        def bank_link_return_path
          raise 'This should be inplemented on your paymentable class'
        end

        # Add this to your paid? method along with other payment methods
        # Example:
        #     def paid?
        #       bank_link_paid? || first_data_paid?
        #     end
        def bank_link_paid?
          self.bank_link_transactions.where(status: "completed").count >= 1
        end
      end
    end
  end
end
