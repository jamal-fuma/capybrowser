# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "capybrowser/version"

Gem::Specification.new do |s|
  s.name        = "capybrowser"
  s.version     = CapyBrowser::VERSION
  s.authors     = ["Jamal M. Natour"]
  s.email       = ["jamal.natour@bbc.co.uk"]
  s.homepage    = ""
  s.summary     = %q{Capybara based Browser library with bbc customizations }
  s.description = %q{C/I at the bbc presents some challenges, this is an attempt to solve some of them}

  s.rubyforge_project = "capybrowser"

  s.files         = Dir.glob('./**/*')
  s.test_files    = Dir.glob('./**/test_*.rb')
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency 'test-unit'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'rcov'
  #s.add_runtime_dependency 'test-unit'
end
