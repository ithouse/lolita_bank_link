require "spec_helper"

describe LolitaBankLink::Billing do
  it "should have paid?" do
    r = Reservation.create!
    r.paid?.should be_false
    request = double("Request")
    request.should_receive(:remote_ip).and_return("11.11.11.11")
    trx = LolitaBankLink::Transaction.add(r,request)
    trx.update_attribute(:status,'completed')
    r.reload
    r.paid?.should be_true
  end
end
