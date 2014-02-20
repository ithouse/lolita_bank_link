$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "lolita-bank-link/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "lolita-bank-link"
  s.version     = LolitaBankLink::VERSION
  s.authors     = ["ITHouse"]
  s.email       = ["info@ithouse.lv"]
  s.homepage    = "http://github.com/ithouse/lolita-bank-link"
  s.summary     = "BankLink payment plugin for Lolita"
  s.description = "BankLink payment plugin using ActiveMerchant for use with Lolita CMS"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_runtime_dependency(%q<rails>, [">= 3.2.0"])
  s.add_development_dependency(%q<sqlite3>, ["~> 1.3"])
  s.add_development_dependency(%q<rspec-rails>, ["~> 2.14.0"])
  s.add_development_dependency(%q<webmock>, ["~> 1"])
  s.add_development_dependency(%q<fabrication>, ["~> 2.1"])
  s.add_development_dependency(%q<database_cleaner>, ["~> 1.2.0"])
  s.add_development_dependency(%q<simplecov>, ["~> 0.8.2"])
  s.add_development_dependency(%q<pry-byebug>, ["~> 1.3.1"])
end
