# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'lolita_bank_link'

Gem::Specification.new do |s|
  s.name        = "lolita_bank_link"
  s.version     = Lolita::BankLink::VERSION
  s.authors     = ["Gatis Tomsons"]
  s.email       = ["gatis@ithouse.cc"]
  s.homepage    = ""
  s.summary     = "BankLink Payment plugin for Lolita"
  s.description = "BankLink Payment plugin for Lolita"
  s.rubyforge_project = "lolita_bank_link"
  s.add_runtime_dependency('rails','>=2.3.10')
  s.add_development_dependency('faker')
  s.add_development_dependency('sqlite3')
  s.files         = [
    "Gemfile",
    "README.md",
    "Rakefile",
    "app/controllers/lolita/bank_link/common_controller.rb",
    "app/controllers/lolita/bank_link/test_controller.rb",
    "app/controllers/lolita/bank_link/transaction_controller.rb",
    "app/helpers/bank_link_helper.rb",
    "app/models/lolita/bank_link/transaction.rb",
    "app/views/lolita/bank_link/payment_form.html.erb",
    "app/views/lolita/bank_link/test/fake_server.html.erb",
    "config/locales/en-US.yml",
    "config/locales/en.yml",
    "config/locales/lv.yml",
    "config/routes.rb",
    "generators/lolita_bank_link/USAGE",
    "generators/lolita_bank_link/lolita_bank_link_generator.rb",
    "generators/lolita_bank_link/templates/bank_link_transactions.erb",
    "init.rb",
    "lib/lolita/bank_link/bank_link.rb",
    "lib/lolita/bank_link/billing.rb",
    "lib/lolita/bank_link/crypt.rb",
    "lib/lolita/bank_link/request.rb",
    "lib/lolita/bank_link/response.rb",
    "lib/lolita/bank_link/version.rb",
    "lib/lolita_bank_link.rb",
    "lolita_bank_link.gemspec",
    "rails/init.rb",
    "spec/lib/bank_link_spec.rb",
    "spec/lib/billing_spec.rb",
    "spec/lib/crypt_spec.rb",
    "spec/lib/response_spec.rb",
    "spec/spec.opts",
    "spec/spec_helper.rb"
  ]
  s.require_paths = ["lib"]
end
