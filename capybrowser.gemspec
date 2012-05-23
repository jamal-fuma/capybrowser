# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "capybrowser/version"

Gem::Specification.new do |s|
  # gem metadata
  s.name        = "capybrowser"
  s.version     = CapyBrowser::VERSION

  s.authors     = ["Jamal M. Natour"]
  s.email       = ["jamal.natour@bbc.co.uk"]

  s.homepage          = "https://repo.dev.bbc.co.uk/qa/capybrowser"
  s.description       = 'C/I at the bbc presents some challenges, this is an attempt to solve some of them'
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
  s.add_runtime_dependency 'metric_fu'
  s.add_runtime_dependency 'ci_reporter'
  s.add_runtime_dependency 'cucumber'
  s.add_runtime_dependency 'mocha'
  s.add_runtime_dependency 'test-unit'
  s.add_runtime_dependency 'rcov'
  s.add_runtime_dependency 'rspec'
  s.add_runtime_dependency 'snailgun'
end
