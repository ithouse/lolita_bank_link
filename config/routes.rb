Rails.application.routes.draw do
  get "/bank_link/checkout" => "lolita_bank_link/transactions#checkout", as: "checkout_bank_link"
  get "/bank_link/answer" => "lolita_bank_link/transactions#answer", as: "answer_bank_link"
  post "/bank_link/answer" => "lolita_bank_link/transactions#answer"
  get "/bank_link/test/:action" => "lolita_bank_link/test"
end
