module CapyBrowser
  module RemoteCommunication
    module HTTP
      extend CapyBrowser::WrappedMethods

      def proxy_uri
        ENV['PROXY']
      end

      def certificate_filename
        ENV['CERT']
      end

      def authorized_username
        ENV['BASIC_AUTH_USER']
      end

      def authorized_password
        ENV['BASIC_AUTH_PASS']
      end

      def certificate
        CertificateAuthentication.build(certificate_filename)
      end

      def http(uri)
        ProxiedConnection.build(proxy_uri).http(uri)
      end

      def https(uri)
        certificate.authenticate( http(uri) )
      end

      def head(path,headers={})
        client = HttpClient.new HttpRequest.new(:head,headers,'')
        client.request(path)
      end

      def get(path,headers={})
        client = HttpClient.new HttpRequest.new(:get,headers,'')
        client.request(path)
      end

      def delete(path,headers={},body='')
        puts "Calling http delete with URL '#{path}'"
        verb = HttpRequest.new(:delete,headers,body)
        return HttpClient.new(verb).request(path)
      end

      def post(path,headers={},body='')
        client = HttpClient.new HttpRequest.new(:post,headers,body)
        client.request(path)
      end

      def put(path,headers={},body='')
        client = HttpClient.new HttpRequest.new(:put,headers,body)
        client.request(path)
      end
      module_function :get,:head,:put,:post,:delete,:http,:https,:certificate,:proxy_uri,:certificate_filename,:authorized_username,:authorized_password
      wrapped_methods :get,:head,:put,:post,:delete,:http,:https,:certificate,:proxy_uri,:certificate_filename,:authorized_username,:authorized_password
    end
  end
end

