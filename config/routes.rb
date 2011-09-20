ActionController::Routing::Routes.draw do |map|
  map.checkout_bank_link '/bank_link/checkout', :controller => 'Lolita::BankLink::Transaction', :action => 'checkout'
  map.answer_bank_link  '/bank_link/answer'  , :controller => 'Lolita::BankLink::Transaction', :action => 'answer'
  map.connect '/bank_link_test/:action', :controller => 'Lolita::BankLink::Test'
end
