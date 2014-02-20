Rails.application.routes.draw do
  get "/checkout" => "lolita_bank_link/transactions#checkout", as: "checkout_bank_link"
  get "/answer" => "lolita_bank_link/transactions#answer", as: "answer_bank_link"
  get "/test/:action" => "lolita_bank_link/test"
end
