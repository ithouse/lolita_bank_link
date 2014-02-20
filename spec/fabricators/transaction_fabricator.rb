Fabricator(:transaction, class_name: "LolitaBankLink::Transaction") do
  status "processing"
  paymentable fabricator: :reservation
  ip "100.100.100.100"
end
