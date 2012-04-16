require 'net/http'
module CapyBrowser
  module ContentNegotiation
    extend CapyBrowser::WrappedMethods
    class Headers
      extend CapyBrowser::WrappedMethods
      include Net::HTTPHeader

      def initialize
        @header = {}
      end

      def add_additional_headers(request_headers={})
        request_headers.each{|name,value|
          self.add_field(name,value)
        }
      end

      def header_names
        to_hash.keys
      end
      wrapped_methods :header_names, :add_additional_headers, :initialize
    end

    def json_content
      negotiation = ContentNegotiation::Headers.new
      negotiation.set_content_type 'application/json'
      negotiation.add_additional_headers 'Accept' => 'application/json'
      negotiation
    end

    def urlencoded_content
      negotiation = ContentNegotiation::Headers.new
      negotiation.set_content_type 'application/x-www-form-urlencoded'
      negotiation.add_additional_headers 'Accept' => 'application/xml'
      negotiation
    end

    module_function :json_content, :urlencoded_content
    wrapped_methods :urlencoded_content, :json_content
  end
end
