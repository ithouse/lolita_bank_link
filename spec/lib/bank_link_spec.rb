require 'spec_helper'

describe LolitaBankLink do
  it 'should have default attributes' do
    expect(LolitaBankLink.private_key).to_not be_nil
    expect(LolitaBankLink.bank_certificate).to_not be_nil
    expect(LolitaBankLink.sender).to eq('TEST')
    expect(LolitaBankLink.url).to eq('https://ib.swedbank.lv/banklink')
    expect(LolitaBankLink.lang).to eq('LAT')
  end

  it 'should check required params for services' do
    services = {
      '1002' => [:service,:version,:snd_id,:stamp,:amount,:curr,:ref,:msg],
      '1101' => [:service,:version,:snd_id,:rec_id,:stamp,:t_no,:amount,:curr,:rec_acc,:rec_name,:snd_acc,:snd_name,:ref,:msg,:t_date],
      '1901' => [:service,:version,:snd_id,:rec_id,:stamp,:ref,:msg]
    }
    services.keys.each do |name|
      expect(LolitaBankLink.required_params_by_service(name)).to eq(services[name])
    end
  end
end
