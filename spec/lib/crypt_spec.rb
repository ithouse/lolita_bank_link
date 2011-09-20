# encoding: utf-8
require File.dirname(__FILE__) + '/../spec_helper'

describe Lolita::BankLink::Crypt do
  before(:each) do
    @params = {:ref=>"", :curr=>"", :service=>"1002", :msg=>"", :amount=>"", :snd_id=>"", :version=>"", :stamp=>"", :a=>:b}
    @signature = "HW/lMtWwpKziwaw67Dz5LEa6E6FauWNdW7Chg67gcfdsK6PsSERiOA8QQxGA\ncnFEDnbUKGJhBI5DR0tezqkrvkPKBOoqtAs73aONHIVKDxPaGdE2BP0gJRoT\ndjzop91f2fuedK7Zmn1MIsVbxltRCXtl8GU/JXGxNEkQnTXHm70="
  end
  it "should sign message" do
    c = Lolita::BankLink::Crypt.new
    c.sign(@params.to_s).should == @signature
  end

  it "should verify mac signature" do
    c = Lolita::BankLink::Crypt.new
    c.verify_mac_signature(@params,@signature).should be_true
  end
end
