require "ipaddr"
# Available statuses
# processing, completed, failed
module LolitaBankLink
  class Transaction < ActiveRecord::Base
    self.table_name = "bank_link_transactions"
    belongs_to :paymentable, polymorphic: true
    after_save :touch_paymentable
    default_scope -> { order(:id) }
    validates_associated :paymentable

    def ip
      IPAddr.new(self[:ip].to_i, Socket::AF_INET).to_s
    end

    def ip=(x)
      self[:ip] = IPAddr.new(x).to_i
    end

    def completed?
      status == 'completed'
    end

    class << self
      # add new transaction in Checkout
      def add payment, request
        LolitaBankLink::Transaction.create!(
          status: "processing",
          paymentable_id: payment.id,
          paymentable_type: payment.class.to_s,
          ip: request.remote_ip
        )
      end
    end

    private

    # trigger "bank_link_trx_saved" on our paymentable model
    def touch_paymentable
      paymentable.bank_link_trx_saved(self) if paymentable
    end
  end
end
