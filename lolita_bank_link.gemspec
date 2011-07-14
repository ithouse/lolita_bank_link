# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'lolita_bank_link'

Gem::Specification.new do |s|
  s.name        = "lolita_bank_link"
  s.version     = Lolita::BankLink::VERSION
  s.authors     = ["Gatis Tomsons"]
  s.email       = ["gatis@ithouse.cc"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}
  s.rubyforge_project = "lolita_bank_link"
  s.add_runtime_dependency('rails','>=2.3.10')
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
