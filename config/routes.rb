if Rails::VERSION::MAJOR >= 3
  Rails.application.routes.draw do
    match '/bank_link/checkout', :as => "checkout_bank_link", :controller => 'Lolita::BankLink::Transaction', :action => 'checkout'
    match '/bank_link/answer', :as => "answer_bank_link", :controller => 'Lolita::BankLink::Transaction', :action => 'answer'
    match '/bank_link_test/:action', :controller => 'Lolita::BankLink::Test'
  end
else
  ActionController::Routing::Routes.draw do |map|
    map.checkout_bank_link '/bank_link/checkout', :controller => 'Lolita::BankLink::Transaction', :action => 'checkout'
    map.answer_bank_link  '/bank_link/answer'  , :controller => 'Lolita::BankLink::Transaction', :action => 'answer'
    map.connect '/bank_link_test/:action', :controller => 'Lolita::BankLink::Test'
  end
end
