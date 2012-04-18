require File.expand_path('../test_helper.rb',__FILE__)

class TestRemoteCommunication_HttpRequest < Test::Unit::TestCase
  include HttpMocksResponses

  def setup
    @url = "http://bbcapi.thepcf.org.uk/actor/reference/-titian"
    @https_url = 'https://api.test.bbc.co.uk/sda/live/arts/artists/-titian'
    @my_cert = '/Users/me/Documents/media/certificates/personal-cert.pem'
    @json_headers = CapyBrowser::ContentNegotiation.json_content
    @json_http_get = CapyBrowser::RemoteCommunication::HttpRequest.new(:get,@json_headers)
    @json_http_head = CapyBrowser::RemoteCommunication::HttpRequest.new(:head,@json_headers)
    @json_http_put = CapyBrowser::RemoteCommunication::HttpRequest.new(:put,@json_headers)
    @json_http_post = CapyBrowser::RemoteCommunication::HttpRequest.new(:post,@json_headers)
    @json_http_delete = CapyBrowser::RemoteCommunication::HttpRequest.new(:delete,@json_headers)

    @json_http_get = CapyBrowser::RemoteCommunication::HttpRequest.new(:get,@json_headers)
    @json_http_head = CapyBrowser::RemoteCommunication::HttpRequest.new(:head,@json_headers)
    @json_http_put = CapyBrowser::RemoteCommunication::HttpRequest.new(:put,@json_headers)
    @json_http_post = CapyBrowser::RemoteCommunication::HttpRequest.new(:post,@json_headers)
    @json_http_delete = CapyBrowser::RemoteCommunication::HttpRequest.new(:delete,@json_headers)

    @http_200 = http_response

    @titian = %q%{"item_count":1,"items":[{"id":"4755","reference":"-titian","name":"Titian","surname":"Titian","forename":null,"birth_year":"1488","death_year":"1576","life_display_dates":"c.1488\u20131576","active_start_date":null,"active_end_date":null,"dbpedia":"Titian","ulan_id":"500031075","nationality":"Italian","artist_website":null,"active_dates":null,"qualifier":null,"painting_count":"74","last_updated":"2011-05-20 10:06:39","deleted":"false"}]}%
  end

  def teardown
    CapyBrowser::RemoteCommunication::HttpRequest.any_instance.unstub(:request)
  end

  def test_http_request_verbs_are_checked_for_correctness
    exception = assert_raises(RuntimeError){
      CapyBrowser::RemoteCommunication::HttpRequest.new(:goo,@json_headers)
    }
    expected = "CapyBrowser::RemoteCommunication::HttpRequest.initialize() failed ->\nCapyBrowser::RemoteCommunication::HttpRequest.method=() failed ->\nHTTP Verb('goo') not supported"
    assert_equal expected, exception.message
  end

  def assert_success
    @json_http_get = CapyBrowser::RemoteCommunication::HttpRequest.new(:get,@json_headers)
    client = CapyBrowser::RemoteCommunication::HttpClient.new(@json_http_get)
    response = client.request(@url)
    assert_equal @titian, response.body
    assert_equal 200, response.code.to_i
  end

  def test_redirect_none
    @http_200.expects(:code).twice.returns('200')
    @http_200.expects(:body).once.returns(@titian)
    CapyBrowser::RemoteCommunication::HttpRequest.any_instance.stubs(:request).returns(@http_200)
    assert_success
  end

  def test_redirect_once
    @http_301 = http_301_redirect('/artists')
    @http_200.expects(:code).twice.returns('200')
    @http_200.expects(:body).once.returns(@titian)
    CapyBrowser::RemoteCommunication::HttpRequest.any_instance.stubs(:request).returns(@http_301,@http_200)
    assert_success
  end

  def test_redirect_twice
    @http_301 = http_301_redirect('/artists')
    @http_302 = http_302_redirect('/artists')

    @http_200.expects(:code).twice.returns('200')
    @http_200.expects(:body).once.returns(@titian)
    CapyBrowser::RemoteCommunication::HttpRequest.any_instance.stubs(:request).returns(@http_301,@http_302,@http_200)
    assert_success
  end

  def test_redirect_three_times
    @http_301 = http_301_redirect('/artists')
    @http_302 = http_302_redirect('/artists')
    @http_303 = http_303_redirect(@url)
    @http_200.expects(:body).once.returns(@titian)
    @http_200.expects(:code).twice.returns('200')
    CapyBrowser::RemoteCommunication::HttpRequest.any_instance.stubs(:request).returns(@http_301,@http_302,@http_303,@http_200)
    assert_success
  end

  def test_raises_on_unauthorised_error_with_no_user_set
    @http_401 = http_401_error
    @http_401.stubs(:code).returns('401')
    CapyBrowser::RemoteCommunication::HttpRequest.any_instance.stubs(:request).returns(@http_401,@http_200)
    exception = assert_raises(RuntimeError){
      client = CapyBrowser::RemoteCommunication::HttpClient.new(@json_http_get)
      client.auth_user = nil
      response = client.request(@url)
    }
    assert_match(/Unauthorised access error \(401\)/, exception.message)
  end

  def test_raises_on_server_error
    @http_500 = http_500_error
    @http_500.stubs(:code).returns('500')
    CapyBrowser::RemoteCommunication::HttpRequest.any_instance.stubs(:request).returns(@http_500,@http_200)
    exception = assert_raises(RuntimeError){
      client = CapyBrowser::RemoteCommunication::HttpClient.new(@json_http_get)
      response = client.request(@url)
    }
    assert_match(/error code was \(500\)/, exception.message)
  end


   def test_retrys_on_unauthorised_error_with_user_set
     @http_301 = http_301_redirect('/artists')
     @http_302 = http_302_redirect(@url)
     @http_401 = http_401_error
     @http_401.stubs(:code).returns('401')
     CapyBrowser::RemoteCommunication::HttpRequest.any_instance.stubs(:request).returns(@http_301,@http_302,@http_401,@http_200)
     CapyBrowser::RemoteCommunication::HttpRequest.any_instance.expects(:basic_auth)
     @json_http_get = CapyBrowser::RemoteCommunication::HttpRequest.new(:get,@json_headers)
     @http_200.expects(:code).times(3).returns('200')
     @http_200.expects(:body).once.returns(@titian)
     assert_nothing_raised{
       client = CapyBrowser::RemoteCommunication::HttpClient.new(@json_http_get)
       client.auth_user = true
      response = client.request(@url)
    }
    assert_success
  end


 #   request = mock("Net::HTTP::Get")
#    request.expects(:[]).with('content-type').returns 'application/json'
#    request.expects(:[]).with('connection').returns 'close'
#    request.expects(:[]).with('host').returns ''
#    request.expects(:path)
#    request.expects(:exec)
#    request.expects(:set_body_internal).with(nil)
#    request.expects(:response_body_permitted?).returns(false)
#    request.expects(:body=)
#    Net::HTTP::Get.expects(:new).returns(request)
    #CapyBrowser::RemoteCommunication::HTTP.expects(:https)

    #@http_200.stubs(:code).twice.returns('200')
    #stub_get_response(@http_200)
    #response = CapyBrowser::RemoteCommunication::HttpClient.new(@json_http_get).request(@url)
end
