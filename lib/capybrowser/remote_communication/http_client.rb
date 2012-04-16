module CapyBrowser
  module RemoteCommunication

    class HttpClient
      extend CapyBrowser::WrappedMethods

      attr_accessor :auth_user

      def initialize(http_request,max_redirects=15)
        @max_redirects  = max_redirects
        @http_request   = http_request
        @auth_user      = true
      end

      def request(request_url)
        redirect(CapyBrowser::URL.new(request_url), @max_redirects)
      end

      def redirect(request_url,redirects)
        response = @http_request.request(request_url)
        case response.code.to_i
        when 301 : handle_301_redirection(response,request_url,redirects-1)
        when 302 : handle_302_redirection(response,request_url,redirects-1)
        when 303 : handle_303_redirection(response,request_url,redirects-1)

        when 200..400 : return response

        when 401 : handle_401_authentication_retry(response,request_url,redirects-1)
        else
          raise "CapyBrowser::RemoteCommunication::HTTP error code was (#{response.code}) for #{request_url}"
        end
      end

      def handle_301_redirection(response,request_url,redirects)
        next_path = next_location(response['location'],request_url)
        raise "Too many redirects followed to redirect again for 301 response: followed (#{redirects}) redirects while retrieving #{request_url}" unless redirects > 0
        redirect(next_path,redirects)
      end

      # I think we are supposed to warn about temp redirection
      def handle_302_redirection(response,request_url,redirects)
        raise "Too many redirects followed to redirect again for 302 response: followed (#{redirects}) redirects while retrieving #{request_url}" unless redirects > 0
        handle_301_redirection(response,request_url,redirects)
      end

      def handle_303_redirection(response,request_url,redirects)
        next_path = next_location(response['location'],request_url)
        raise "Too many redirects followed to redirect again for 303 response: followed (#{redirects}) redirects while retrieving #{request_url}" unless redirects > 0
        return CapyBrowser::RemoteCommunication::HTTP.get(next_path,@http_request.headers)
      end

      def handle_401_authentication_retry(response,request_url,redirects)
        raise "Unauthorised access error (401) for #{request_url.to_s}" if @auth_user.nil?
        raise "Too many redirects followed to retry for 401 authentication failure: followed (#{redirects}) redirects for #{request_url}" unless redirects > 0
        user_name ||= CapyBrowser::RemoteCommunication::HTTP.authorized_username
        user_pass ||=  CapyBrowser::RemoteCommunication::HTTP.authorized_password
        @http_request.basic_auth(user_name,user_pass)
        return redirect(request_url,redirects)
      end

      def next_location(next_hop,uri)
        raise "Location header not present in response" if next_hop.nil?
        uri.relative_to next_hop
      end

      wrapped_methods :next_location, :redirect, :request, :initialize,
      :handle_401_authentication_retry, :handle_303_redirection, :handle_302_redirection, :handle_301_redirection
    end
  end
end
