require 'bundler/setup'
require 'capybrowser'
require 'capybrowser/rake/tasks'

default_gem_build_task CapyBrowser.gem
desc "Run features against local test environment"
task(:features, [:opts] => ['features:local:http:test'])
