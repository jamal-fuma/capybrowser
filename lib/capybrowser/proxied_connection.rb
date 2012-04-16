require 'net/http'
require 'net/https'

module CapyBrowser
  module ProxiedConnection
    extend CapyBrowser::WrappedMethods
    class NetHttpBackend
      extend CapyBrowser::WrappedMethods
      def direct(uri)
        uri = CapyBrowser::URL.new(uri.to_s)
        http = Net::HTTP.new(uri.host, uri.port)
      end
      def indirect(uri,proxy)
        uri   = CapyBrowser::URL.new(uri.to_s)
        proxy = CapyBrowser::URL.new(proxy.to_s)
        Net::HTTP.new(uri.host, uri.port,proxy.host,proxy.port)
      end
      wrapped_methods :direct, :indirect
    end

    class ProxyStrategyImpl
      extend CapyBrowser::WrappedMethods
      def initialize(&block)
        @block = block
        @backend = NetHttpBackend.new
      end

      def http(url)
        url  = CapyBrowser::URL.new(url.to_s)
        http = @block.call(@backend,url)
        http.use_ssl = url.https?
        http
      end

      def self.proxied_connection(proxy_path)
        begin
          raise "Missing proxy uri" if proxy_path.empty?
          ProxyStrategyImpl.new{|backend,uri|
            backend.indirect(uri, proxy_path)
          }
        rescue
          raise "#{Module.nesting[0]}.#{__method__}() failed ->\n#{$!.message}"
        end
      end

      def self.direct_connection
        begin
          ProxyStrategyImpl.new{|backend,url|
            backend.direct(url)
          }
        rescue
          raise "#{Module.nesting[0]}.#{__method__}() failed ->\n#{$!.message}"
        end
      end
    end

    def build(proxy_path)
      proxy = ProxyStrategyImpl.proxied_connection(proxy_path) rescue nil
      proxy ||= ProxyStrategyImpl.direct_connection
    end
    module_function :build
    wrapped_methods :build
  end
end
