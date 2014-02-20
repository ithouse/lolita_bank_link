require "spec_helper"

describe LolitaBankLink::Request do
  let(:payment){ double(id: 1, price: 200, currency: "EUR", description: "Some text")}
  let(:transaction){ double(id: 2)}

  subject{ described_class.new payment, transaction }

  describe "#build_form_data" do
    it "returns hash with request data" do
      expect(subject.build_form_data).to eq({:stamp=>"1", :ref=>"2", :snd_id=>"TEST", :amount=>"2.00", :curr=>"EUR", :msg=>"Some text", :service=>"1002", :version=>"008", :mac=>"SKxi0WEsOscm7x9xIMAkZKwNkScray77bMKGFEzxMBJIP3czyfnqSU0c5Ejf\nKDbp8MXptlzMNQSGDhkR4QEnZV1W+pU5Cnv1KFzLe9hg5UsoqN+GYPPzUUJP\nhCwwa85PN1/bAmgnyMipOGUkWQKWwwOFa/RyndxDrWiEMAte8wM=", :lang=>"LAT", :encoding=>"UTF-8"})
    end
  end
end
