# encoding: utf-8
require File.dirname(__FILE__) + '/../spec_helper'

describe Lolita::BankLink do
  it "should have default attributes" do
    Lolita::BankLink.private_key.should_not be_nil
    Lolita::BankLink.bank_certificate.should_not be_nil
    Lolita::BankLink.sender.should == "TEST"
    Lolita::BankLink.url.should == "https://ib.swedbank.lv/banklink"
    Lolita::BankLink.lang.should == "LAT"
  end

  it "should check required params for services" do
    services = {
      '1002' => [:service,:version,:snd_id,:stamp,:amount,:curr,:ref,:msg],
      '1101' => [:service,:version,:snd_id,:rec_id,:stamp,:t_no,:amount,:curr,:rec_acc,:rec_name,:snd_acc,:snd_name,:ref,:msg,:t_date],
      '1901' => [:service,:version,:snd_id,:rec_id,:stamp,:ref,:msg]
    }
    services.keys.each do |name|
      Lolita::BankLink.required_params_by_service(name).should == services[name]
    end
  end
end
