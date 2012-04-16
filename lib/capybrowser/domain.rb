module CapyBrowser
  class Domain
    extend CapyBrowser::WrappedMethods
    attr_reader :name, :host

    predicate_methods(:live,:int,:stage,:test){|env|
      code = []
      code << %q{raise "Cant find the name of the current environment" if self.name.nil?}
      code << %q{'METHOD_NAME' == self.name}
      code
    }

    named_constructors([:live,:int,:stage,:test]){|env|
      components = []
      components << env unless env == 'live'
      components <<  'bbc.co.uk'
      [ %W('#{env}'), %W('#{components.join(".")}') ]
    }
    delegated_methods(:to_http_uri,:to_https_uri){ |method_name| 'self.to_uri' }

    def initialize(name,host)
      @name = name
      @host = host
    end

    def to_s
      lines = []
      lines << "---"
      lines << "#{self.host} on #{self.name}"
      lines << "---"
      lines << "#{self.host} on #{self.name} is not live" unless self.live?
      lines << "#{self.host} on #{self.name} is not stage" unless self.stage?
      lines << "#{self.host} on #{self.name} is not int" unless self.int?
      lines << "#{self.host} on #{self.name} is not test" unless self.test?
      lines << "---"
      lines.join "\n"
    end

    def to_uri
      URL.new(self.host)
    end

    wrapped_methods :initialize, :to_s, :to_uri
  end


  class Subdomain
    extend CapyBrowser::WrappedMethods
    attr_writer :prefix, :name, :host
    delegated_methods(:name,:host,:to_s,:to_http_uri,:to_https_uri){ |method_name| 'self.domain' }
    def initialize(name,host,prefix)
      @prefix = prefix
      @name   = name
      @host   = host
    end
    def domain
      Domain.new(@name,[@prefix,@host].join('.'))
    end
    wrapped_methods :initialize, :domain
  end
end
