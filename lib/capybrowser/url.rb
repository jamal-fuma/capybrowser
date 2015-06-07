require 'uri'
module CapyBrowser
  class URL
    extend WrappedMethods

    delegated_methods(:empty?){ |method_name| 'self.to_s' }
    delegated_methods(:host,:to_s,:user=,:+,:scheme,:port,:request_uri,:absolute?,:relative?){ |method_name| '@uri' }
    named_constructors([:http,:https]){|method_name| [%q{"METHOD_NAME://#{args.join("").gsub(/^((?:https|http):\/\/)/,"")}"}] }
    predicate_methods(:https){|method_name| [%q{self.scheme == 'https'}] }

    def initialize(path)
      begin
        puts "Parsing '#{path.inspect}' as URL: "
        path = path.to_s.strip
        @uri = URI.parse(path)
      rescue
        raise "Parsing '#{path.inspect}' as URL failed"
      end
    end

    def relative_to(relative_url)
      raise "I am not absolute so cannot make relative? urls" unless self.absolute?
      absolute_url = URL.new(relative_url)
      return absolute_url if absolute_url.absolute?
      absolute_path = self + absolute_url.to_s
      URL.new(absolute_path.to_s)
    end

    def to_http_uri
      URL.http(self.to_s)
    end

    def to_https_uri
      URL.https(self.to_s)
    end

    wrapped_methods :initialize, :relative_to, :to_http_uri, :to_https_uri
  end
end
