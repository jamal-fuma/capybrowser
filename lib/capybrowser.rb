require "capybrowser/version"
require "capybrowser/wrapped_methods"
require "capybrowser/certificate_authentication"
require "capybrowser/content_negotiation"
require "capybrowser/url"
require "capybrowser/domain"
require "capybrowser/proxied_connection"

require 'capybrowser/remote_communication/http'
require 'capybrowser/remote_communication/http_request'
require 'capybrowser/remote_communication/http_client'
require 'capybrowser/remote_communication/multipart_form'
require 'capybrowser/remote_communication/multipart_form_boundry'
require 'capybrowser/remote_communication/encoded_field'
require 'capybrowser/remote_communication/encoded_file'

require 'capybrowser/rake'

module CapyBrowser
  def gem
    CapyBrowser::Rake::Gem.new('capybrowser',CapyBrowser::VERSION)
  end

  def bundler
    CapyBrowser::Rake::Bundler.new(CapyBrowser.gem)
  end

  module_function :gem, :bundler
end
