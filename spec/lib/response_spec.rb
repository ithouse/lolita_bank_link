# encoding: utf-8
require File.dirname(__FILE__) + '/../spec_helper'

describe Lolita::BankLink::Response do
  it "should validate params" do
    @parameters = {"VK_T_NO"=>"109", "encoding"=>"UTF-8", "VK_SND_NAME"=>"GUNĀRS GRUNDŠTOKS", "VK_REF"=>"1", "VK_REC_ID"=>"TEST", "VK_SND_ACC"=>"LV12HABA0000000000000", "VK_STAMP"=>"68", "VK_T_DATE"=>"21.07.2011", "VK_AMOUNT"=>"0.09", "VK_REC_NAME"=>"ITH GROUP SIA", "VK_SERVICE"=>"1101", "VK_LANG"=>"LAT", "VK_AUTO"=>"N", "VK_MSG"=>"RentMama.com - R07117973", "VK_ENCODING"=>"UTF-8", "VK_VERSION"=>"008", "VK_SND_ID"=>"HP", "locale"=>"lv", "VK_MAC"=>"", "VK_CURR"=>"LVL", "VK_REC_ACC"=>"LV12HABA0000000000000"}
    rs = Lolita::BankLink::Response.new(@parameters)
    @parameters["VK_MAC"] = rs.crypt.calc_mac_signature(rs.params, '1101')
    rs = Lolita::BankLink::Response.new(@parameters)
    rs.valid?.should == true
  end
end
