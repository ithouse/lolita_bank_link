class Reservation < ActiveRecord::Base
  include LolitaBankLink::Billing

  def paid?
    bank_link_paid?
  end

  # Methods for BankLink
  #-----------------------
  def price
    full_price
  end

  # string up to 125 symbols
  def description
    "testing"
  end

  def currency
    "EUR"
  end

  def bank_link_trx_saved trx
    case trx.status.to_s
    when "processing"
      update_attribute(:status, "payment")
    when "completed"
      update_attribute(:status, "completed")
    when "rejected"
      update_attribute(:status, "rejected")
    end
  end

  def bank_link_return_path
    "/reservation/done"
  end
  #-----------------------
end
