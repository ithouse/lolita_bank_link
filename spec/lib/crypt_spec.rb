require "spec_helper"

describe LolitaBankLink::Crypt do
  let(:params){ {ref: "12", curr: "EUR", service:"1002", msg: "X12", amount: "20.000", snd_id: "TEST", version: "008", stamp: "123"} }
  subject{ LolitaBankLink::Crypt.new }

  it "should sign message" do
    expect(subject.sign(params.to_s)).to eq("ER6RRFtrkh+mBJXj/q1kFtboicROnfvqPjR8TcvIHYOHntJdGtTyRFQXUKH9\no21I4zPTkMCWPILSiztUzySG6Kn9PnXb5AUyc4SpT3Pb1CqXDIXgbce2Sw8q\ndZvC7YrjU2KwrGotCzNX5v9xmg/KqA9DSyA9BLFpOfqmUE9gfUs=")
  end

  it "should verify mac signature" do
    expect(subject.verify_mac_signature(params, "MXGxIDxFKw8PuGXNLo2iYkErP2ee+hM3Umd9kxOZY05pVN5O818ON0yoYwtr\n3njndVkfIFguSrErF3zv0NJ3psCOZWyNFZ31FoiGhWsiKhb1WVTXq9g3dHj6\nsimk+D8XPLb9pEEOrQ7/b+S40nEjtTjlAzZ5kmukiVPy73sN0jY=")).to be_true
  end
end
