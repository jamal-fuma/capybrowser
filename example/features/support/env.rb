# encoding: UTF-8
require 'bundler/setup'

require 'capybrowser'

require 'simplecov'
SimpleCov.start do
    coverage_dir "tmp/doc/coverage"
end

require 'stretcher'
require 'cucumber'
require 'rspec'
