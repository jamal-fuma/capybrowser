module CapyBrowser
  module RemoteCommunication
    class HttpRequest
      extend CapyBrowser::WrappedMethods
      include Net::HTTPHeader
      delegated_methods(:request_uri){|method_name| '@url' }
      def initialize(method,request_headers={},request_body='')
        self.method  = method
        @header  = request_headers
        @body    = request_body
        @url     = nil
      end

      def method=(method)
        raise "HTTP Verb('#{method.to_s}') not supported" unless [:post,:put,:delete,:head,:get].include?(method)
        match = method.to_s.match(/^(.)(.*)$/)
        @class_name_str ="Net::HTTP::#{match[1].upcase + match[2].downcase}"
        @method = method
      end

      def request(uri)
        puts "Parsing '#{uri}' as #{@class_name_str} URL: "
        @url  = CapyBrowser::URL.new(uri.to_s)
        @request = eval(@class_name_str).new(@url.request_uri, @header)
        client  = CapyBrowser::RemoteCommunication::HTTP.https(@url)
        request_body = encode_request_entity(@request, @body) rescue @request
        response(client,request_body)
      end

      def headers
        @header
      end

      def response(client,request_body)
        client.request( request_body )
      end

      def encode_request_entity(request,request_body)
        return case(request['content-type'])

        when %r{^multipart/form-data, boundary=(.*)$}
          encode_multipart_attachment(request,request_body)

        when 'application/x-www-form-urlencoded'
          encode_url_form_parameters(request,request_body)

        when 'application/json'
          encode_string_data(request,request_body)

        when 'application/xml'
          encode_string_data(request,request_body)

        else
          if (request_body.nil? || request_body.empty?)
            request
          end
          raise "Content-Type: '#{request['content-type']}' header not understood"
        end
      end

      def encode_multipart_attachment(request,request_body)
        raise "Attachment content type specifed but content not provided" if request_body.nil?
        CapyBrowser::RemoteCommunication::MultipartForm.new(request_body).encode(request)
      end

      def encode_url_form_parameters(request,request_body)
        raise "URL Encoded Form Parameters content type specifed but content not provided" if request_body.nil?
        request.set_form_data = request_body
        request
      end

      def encode_string_data(request,request_body)
        raise "body content content type specified but not provided" if request_body.nil?
        request.body = request_body
        request
      end
      wrapped_methods :initialize,:headers, :method=,:request, :encode_request_entity, :encode_multipart_attachment, :encode_url_form_parameters, :encode_string_data
    end
  end
end
