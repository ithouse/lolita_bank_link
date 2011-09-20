# encoding: utf-8
require File.dirname(__FILE__) + '/../spec_helper'

describe Lolita::BankLink::Billing do
  it "should have paid?" do
    r = Reservation.create!
    r.paid?.should be_false
    request = mock("Request")
    request.should_receive(:remote_ip).and_return("11.11.11.11")
    trx = Lolita::BankLink::Transaction.add(r,request)
    trx.update_attribute(:status,'completed')
    r.reload
    r.paid?.should be_true
  end
end