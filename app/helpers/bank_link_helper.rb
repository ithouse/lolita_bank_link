module BankLinkHelper
  def bank_link_form_data paymentable, transaction
    data = Lolita::BankLink.build_form_data(paymentable, transaction)
    raw data.collect { |key, value| hidden_field_tag("VK_#{key.to_s.upcase}", value.to_s ) }
  end
end