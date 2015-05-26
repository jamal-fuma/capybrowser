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

            result = case response.code.to_i
            when 100..199
               handle_http_information(response,request_url,redirects-1)
            when 200..299
               handle_http_success(response,request_url,redirects-1)
            when 300..399
               handle_http_redirection(response,request_url,redirects-1)
            when 400..499
               handle_http_authorization(response,request_url,redirects-1)
            when 500..599
               handle_http_errors(response,request_url,redirects-1)
            else
                raise "CapyBrowser::RemoteCommunication::HTTP error code was (#{response.code}) for #{request_url}"
            end
         end

         def handle_http_information(response,request_url,redirects)
            result = case response.code.to_i
            when 100
               handle_100_continue(response)
            when 101
               handle_101_switching_protocols(response)
            when 102..199
               raise "CapyBrowser::RemoteCommunication::HTTP 1xx code was (#{code}) for #{request_url} after following #{redirects} redirects"
            else
               raise "CapyBrowser::RemoteCommunication::HTTP error code was (#{code}) for #{request_url} after following #{redirects} redirects"
            end
         end

         def handle_100_continue(response)
            return response
         end

         def handle_101_switching_protocols(response)
            return response
         end

         def handle_http_success(response,request_url,redirects)
            result = case response.code.to_i
            when 200
               handle_200_okay(response)
            when 201
               handle_201_created(response)
            when 202
               handle_202_accepted(response)
            when 203
               handle_203_non_authoritative_information(response)
            when 204
               handle_204_no_content(response)
            when 205
               handle_205_reset_document_view(response)
            when 206
               handle_206_partial_content(response)
            when 207..299
               raise "CapyBrowser::RemoteCommunication::HTTP 2xx code was (#{code}) for #{request_url} after following #{redirects} redirects"
            else
               raise "CapyBrowser::RemoteCommunication::HTTP error code was (#{code}) for #{request_url} after following #{redirects} redirects"
            end
         end
         def handle_200_okay(response)
            return response
         end

         def handle_201_created(response)
            return response
         end

         def handle_202_accepted(response)
            return response
         end

         def handle_203_non_authoritative_information(response)
            return response
         end

         def handle_204_no_content(response)
            return response
         end

         def handle_205_reset_document_view(response)
            return response
         end

         def handle_206_partial_content(response)
            return response
         end

         def handle_http_redirection(response,request_url,redirects)
            result = case response.code.to_i
            when 300
               handle_300_multiple_choices(response,request_url,redirects-1)
            when 301
               handle_301_moved_permanantly(response,request_url,redirects-1)
            when 302
               handle_302_found(response,request_url,redirects-1)
            when 303
               handle_303_see_other(response,request_url,redirects-1)
            when 307
               handle_307_temporary_redirection(response,request_url,redirects-1)
            when 308..399
               raise "CapyBrowser::RemoteCommunication::HTTP 3xx code was (#{code}) for #{request_url} after following #{redirects} redirects"
            else
               raise "CapyBrowser::RemoteCommunication::HTTP error code was (#{code}) for #{request_url} after following #{redirects} redirects"
            end
         end
         def handle_300_multiple_choices(response,request_url,redirects)
            next_path = next_location(response['location'],request_url)
            raise "Too many redirects followed to redirect again for 300 response: followed (#{redirects}) redirects while retrieving #{request_url}" unless redirects > 0
            redirect(next_path,redirects)
         end

         def handle_301_moved_permanantly(response,request_url,redirects)
            next_path = next_location(response['location'],request_url)
            raise "Too many redirects followed to redirect again for 301 response: followed (#{redirects}) redirects while retrieving #{request_url}" unless redirects > 0
            redirect(next_path,redirects)
         end

         # I think we are supposed to warn about temp redirection
         def handle_302_found(response,request_url,redirects)
            raise "Too many redirects followed to redirect again for 302 response: followed (#{redirects}) redirects while retrieving #{request_url}" unless redirects > 0
            handle_301_moved_permanantly(response,request_url,redirects)
         end

         def handle_303_see_other(response,request_url,redirects)
            next_path = next_location(response['location'],request_url)
            raise "Too many redirects followed to redirect again for 303 response: followed (#{redirects}) redirects while retrieving #{request_url}" unless redirects > 0
            redirect(next_path,redirects)
            return CapyBrowser::RemoteCommunication::HTTP.get(next_path,@http_request.headers)
         end

         def handle_307_temporary_redirection(response,request_url,redirects)
            next_path = next_location(response['location'],request_url)
            raise "Too many redirects followed to redirect again for 307 response: followed (#{redirects}) redirects while retrieving #{request_url}" unless redirects > 0
            return CapyBrowser::RemoteCommunication::HTTP.post(next_path,@http_request.headers,"")
         end

         def next_location(next_hop,uri)
            raise "Location header not present in response" if next_hop.nil?
            uri.relative_to next_hop
         end

         def handle_http_authorization(response,request_url,redirects)
            result = case response.code.to_i
            when 400
               raise "CapyBrowser::RemoteCommunication::HTTP 4xx code was (#{code}) for #{request_url} after following #{redirects} redirects"
            when 401
               handle_401_authentication_retry(response,request_url,redirects-1)
            when 402
               handle_402_payment_required(response,request_url,redirects-1)
            when 403
               handle_403_forbidden(response)
            when 404
               handle_404_not_found(response)
            when 405
               handle_405_method_not_allowed(response)
            when 406
               handle_406_not_acceptable(response)
            when 407..416
               raise "CapyBrowser::RemoteCommunication::HTTP 4xx code was (#{code}) for #{request_url} after following #{redirects} redirects"
            when 417
               handle_417_expectation_failed(response)
            when 418..425
               raise "CapyBrowser::RemoteCommunication::HTTP 4xx code was (#{code}) for #{request_url} after following #{redirects} redirects"
            when 426
               handle_426_upgrade_required(response,request_url,redirects-1)
            when 427..499
               raise "CapyBrowser::RemoteCommunication::HTTP 4xx code was (#{code}) for #{request_url} after following #{redirects} redirects"
            else
               raise "CapyBrowser::RemoteCommunication::HTTP error code was (#{code}) for #{request_url} after following #{redirects} redirects"
            end
         end

         def handle_401_authentication_retry(response,request_url,redirects)
            raise "Unauthorised access error (401) for #{request_url.to_s}" if @auth_user.nil?
            raise "Too many redirects followed to retry for 401 authentication failure: followed (#{redirects}) redirects for #{request_url}" unless redirects > 0
            user_name ||= CapyBrowser::RemoteCommunication::HTTP.authorized_username
            user_pass ||=  CapyBrowser::RemoteCommunication::HTTP.authorized_password
            @http_request.basic_auth(user_name,user_pass)
            return redirect(request_url,redirects)
         end

         def handle_402_payment_required(response,request_url,redirects)
            raise "Too many redirects followed to retry for 426 upgrade of protocol: followed (#{redirects}) redirects for #{request_url}" unless redirects > 0
            return response
         end

         def handle_403_forbidden(response)
            return response
         end

         def handle_404_not_found(response)
            return response
         end

         def handle_405_method_not_allowed(response)
            return response
         end

         def handle_406_not_acceptable(response)
            return response
         end

         def handle_417_expectation_failed(response)
            return response
         end

         def handle_426_upgrade_required(response,request_url,redirects)
            raise "Too many redirects followed to retry for 426 upgrade of protocol: followed (#{redirects}) redirects for #{request_url}" unless redirects > 0
            return response
         end

         def handle_http_errors(response,request_url,redirects)
            raise "CapyBrowser::RemoteCommunication::HTTP 5xx code was (#{code}) for #{request_url} after following #{redirects} redirects"
         end
         wrapped_methods :initialize,
         :request,
         :redirect,
         :handle_http_information,
         :handle_100_continue,
         :handle_101_switching_protocols,
         :handle_http_success,
         :handle_200_okay,
         :handle_201_created,
         :handle_202_accepted,
         :handle_203_non_authoritative_information,
         :handle_204_no_content,
         :handle_205_reset_document_view,
         :handle_206_partial_content,
         :handle_http_redirection,
         :handle_300_multiple_choices,
         :handle_301_moved_permanantly,
         :handle_302_found,
         :handle_303_see_other,
         :handle_307_temporary_redirection,
         :next_location,
         :handle_http_authorization,
         :handle_401_authentication_retry,
         :handle_402_payment_required,
         :handle_403_forbidden,
         :handle_404_not_found,
         :handle_405_method_not_allowed,
         :handle_406_not_acceptable,
         :handle_417_expectation_failed,
         :handle_426_upgrade_required,
         :handle_http_errors
      end # CapyBrowser::RemoteCommunication::HttpClient
   end # CapyBrowser::RemoteCommunication
end # CapyBrowser
