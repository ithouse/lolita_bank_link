require 'ipaddr'

module Lolita::BankLink
  class Transaction < ActiveRecord::Base
    set_table_name :bank_link_transactions
    belongs_to :paymentable, :polymorphic => true
    after_save :touch_paymentable
    
    def ip
      IPAddr.new(self[:ip], Socket::AF_INET).to_s
    end

    def ip=(x)
      self[:ip] = IPAddr.new(x).to_i
    end
    
    # add new transaction in Checkout
    def self.add payment, request
      Lolita::BankLink::Transaction.create!(
        :status => :processing,
        :paymentable_id => payment.id,
        :paymentable_type => payment.class.to_s,
        :ip => request.remote_ip
      )      
    end
    
    private
    
    # trigger "payment_trx_saved" on our paymentable model
    def touch_paymentable
      paymentable.payment_trx_saved(self) if paymentable
    end
  end
end