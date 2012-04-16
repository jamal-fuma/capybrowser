require 'openssl'
module CapyBrowser
  module CertificateAuthentication
    extend CapyBrowser::WrappedMethods
    class SSLCertificate
      extend CapyBrowser::WrappedMethods
      attr_reader :filename,:verify_mode
      def initialize(filename,verify_mode=OpenSSL::SSL::VERIFY_NONE)
        @filename = filename
        @verify_mode = verify_mode
      end

      def cert
        OpenSSL::X509::Certificate.new File.read(@filename)
      end

      def key
        OpenSSL::PKey::RSA.new( File.read(@filename) , nil)
      end

      def to_hash
        hash = {}
        hash[:cer] = @filename
        hash[:key] = @filename
        hash
      end

      def authenticate(http)
        raise "Unable to use the certificate #{@filename.inspect}" unless File.exists?(@filename)
        if http.use_ssl
          http.verify_mode = self.verify_mode
          http.cert        = self.cert
          http.key         = self.key
        end
        http
      end
      wrapped_methods :authenticate,:to_hash,:key,:cert,:initialize
    end

    class CertificateStrategyImpl
      extend CapyBrowser::WrappedMethods
      delegated_methods(:to_hash){|method_name| '@certificate' }
      def initialize(filename,&block)
        @block = block
        @certificate = SSLCertificate.new(filename)
      end

      def authenticate(http)
        @block.call(http,@certificate)
      end

      wrapped_methods :initialize, :authenticate

      def self.authenticated(filename)
        begin
          raise "Unable to use the certificate #{filename.inspect}" unless File.exists?(filename)
          CertificateStrategyImpl.new(filename){|http,certificate|
            certificate.authenticate(http)
          }
        rescue
          raise "#{Module.nesting[0]}.#{__method__}() failed ->\n#{$!.message}"
        end
      end

      def self.unauthenticated(filename)
        begin
          CertificateStrategyImpl.new(filename){|http,certificate|
            http
          }
        rescue
          raise "#{Module.nesting[0]}.#{__method__}() failed ->\n#{$!.message}"
        end
      end
    end

    def build(filename)
      cert = nil
      cert ||= CertificateStrategyImpl.authenticated(filename) rescue nil
      cert ||= CertificateStrategyImpl.unauthenticated(filename)
      cert
    end
    module_function :build
    wrapped_methods :build
  end
end
