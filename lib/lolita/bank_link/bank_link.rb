module Lolita
  module BankLink
    mattr_accessor :bank_certificate, :private_key, :sender, :url, :lang

    # defaults
    self.url = "https://ib.swedbank.lv/banklink"
    self.lang = "LAT"
  end
end