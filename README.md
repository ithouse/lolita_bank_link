# LolitaBankLink

SWEDBANK plugin for Lolita

## Usage

Add to your Gemfile `gem "lolita-bank-link"`
To use with Rails `< 4.0` add also `gem "strong_parameters"`

Then run generator `rails g lolita_bank_link`

To setup your paymentable object see `spec/dummy/app/models/reservation.rb`

## ENV variables

    BANK_LINK_PRIVATE_KEY: ~/production/shared/config/keyfile.key
    BANK_LINK_BANK_CERTIFICATE: ~/production/shared/config/bank_link_cert.pem
    BANK_LINK_SENDER: TEST
    BANK_LINK_URL: https://ib.swedbank.lv/banklink
    BANK_LINK_LANG: LAT
