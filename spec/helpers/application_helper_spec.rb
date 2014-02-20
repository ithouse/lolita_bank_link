require "spec_helper"

describe LolitaBankLink::ApplicationHelper do
  describe "#render_bank_link_form_data" do
    let(:payment_request){ double(build_form_data: {data: "333"}) }

    it "should return string with hidden fields" do
      expect(helper.render_bank_link_form_data(payment_request)).to match(/name="VK_DATA".*value="333"/)
    end
  end
end

