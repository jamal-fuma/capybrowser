# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "capybrowser/version"

Gem::Specification.new do |s|
  # gem metadata
  s.name        = "capybrowser"
  s.version     = CapyBrowser::VERSION

  s.authors     = ["Jamal M. Natour"]
  s.email       = ["jamal.natour@bbc.co.uk"]

  s.homepage          = "https://github.com/jamal-fuma/capybrowser"
  s.description       = 'C/I at scale presents some challenges, this is an attempt to solve some of them'
  s.summary           = "capybrowser-#{CapyBrowser::VERSION}"
  s.rubyforge_project = "capybrowser"

  # files included in gem
  s.bindir        = 'bin'
  s.files         = %x[bin/manifest].chomp.split("\n")
  s.test_files    = Dir.glob('test/**/test_*.rb')
  s.executables   = ['bootstrap.sh','vagrant.sh','manifest']
  s.require_paths = ['lib']

  # dependencies
  s.add_runtime_dependency 'rake'
  s.add_runtime_dependency 'cucumber'
  s.add_runtime_dependency 'ci_reporter_cucumber'
  s.add_runtime_dependency 'ci_reporter_minitest'
  s.add_runtime_dependency 'ci_reporter_rspec'
  s.add_runtime_dependency 'mocha'
  s.add_runtime_dependency 'simplecov'
  s.add_runtime_dependency 'minitest'
  s.add_runtime_dependency 'rspec'
end
