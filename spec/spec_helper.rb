# encoding: utf-8
require 'rubygems'
gem 'rails', '~>2.3'
require 'active_record'
require 'spec'
#require 'faker'

BANK_LINK_PRIVATE_KEY = File.dirname(__FILE__)+"/fixtures/private_key.pem"
BANK_LINK_BANK_CERTIFICATE  = File.dirname(__FILE__)+"/fixtures/certificate.pem"
BANK_LINK_SENDER = "TEST"

# init bank_link
require File.dirname(__FILE__)+'/../init.rb'

ActiveRecord::Base.logger = Logger.new(File.open("#{File.dirname(__FILE__)}/database.log", 'w+'))
ActiveRecord::Base.establish_connection({ :database => ":memory:", :adapter => 'sqlite3', :timeout => 500 })

# setup I18n
I18n.available_locales = [:en,:lv,:ru,:fr]
I18n.default_locale = :en
I18n.locale = :en

# load transaction module
require File.dirname(__FILE__)+'/../app/models/lolita/bank_link/transaction.rb'
# load response
require File.dirname(__FILE__)+'/../lib/lolita/bank_link/response.rb'


# Add models
ActiveRecord::Schema.define do
  create_table :bank_link_transactions do |t|
    t.string :status, :default => :processing
    t.references :paymentable, :polymorphic => true
    t.string :ip, :length => 10

    t.timestamps
  end

  create_table :reservations do |t|
    t.integer :full_price
    t.string :status

    t.timestamps
  end
end

class Reservation < ActiveRecord::Base
  
  def paid?
    false
  end

  include Lolita::BankLink::Billing
  
  # Methods for BankLink
  #-----------------------
  def price
    full_price
  end

  # string up to 125 symbols
  def description
    "testing"
  end

  # returns 3 letters string according to http://en.wikipedia.org/wiki/ISO_4217
  def currency
    "LVL"
  end
  
  def payment_trx_saved trx
    case trx.status
    when :processing
      update_attribute(:status, 'payment')
    when :completed
      update_attribute(:status, 'completed')
    when :rejected
      update_attribute(:status, 'rejected')
    end
  end
  #-----------------------
end

Spec::Runner.configure do |config|
  config.before(:each) do
    ActiveRecord::Base.connection.execute "DELETE from bank_link_transactions"
    ActiveRecord::Base.connection.execute "DELETE from reservations"
  end
end
