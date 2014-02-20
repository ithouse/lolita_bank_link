module LolitaBankLink
  module ApplicationHelper
    include Rails.application.routes.url_helpers

    def render_bank_link_form_data payment_request
      payment_request.build_form_data(return: answer_bank_link_url(protocol: 'https')).collect do |key, value| 
        hidden_field_tag("VK_#{key.to_s.upcase}", value, id: nil )
      end.join
    end
  end
end
