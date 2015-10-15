require File.expand_path('../test_helper.rb',__FILE__)

class TestRemoteCommunication < Minitest::Test
  include HttpMocksResponses
  def setup
    @url = "http://www.bbc.co.uk/arts/yourpaintings"
   # @url = "http://bbcapi.thepcf.org.uk/actor/reference/wilson-a-"
    # titian seems to have disappeared -- @url = "http://bbcapi.thepcf.org.uk/actor/reference/-titian"
    @https_url = 'https://ssl.test.bbc.co.uk/arts/yourpaintings'
    #@https_url = 'https://api.bbc.co.uk/sda/live/arts/artists/-titian'
    # titian seems to have disappeared from pcf but wilson is not on test domain -- @url = "http://bbcapi.thepcf.org.uk/actor/reference/-titian"
    @my_cert = '/Users/me/Documents/media/certificates/personal-cert.pem'
    @headers = CapyBrowser::ContentNegotiation.json_content
    ENV['CERT']= @my_cert
    ENV['PROXY'] = ENV['HTTP_PROXY']
  end

  def test_proxy_uri
    puts "proxy = '#{ENV['PROXY']}'"
    assert_equal ENV['PROXY'], CapyBrowser::RemoteCommunication::HTTP.proxy_uri
  end

  def test_certificate_filename
    ENV['CERT'] = 'bar'
    assert_equal 'bar', CapyBrowser::RemoteCommunication::HTTP.certificate_filename
  end

  def test_authorized_username
    ENV['BASIC_AUTH_USER'] = 'bar'
    assert_equal 'bar', CapyBrowser::RemoteCommunication::HTTP.authorized_username
  end

  def test_authorized_password
    ENV['BASIC_AUTH_PASS'] = 'bar'
    assert_equal 'bar', CapyBrowser::RemoteCommunication::HTTP.authorized_password
  end

  def test_certificate
    assert_respond_to CapyBrowser::RemoteCommunication::HTTP.certificate, :authenticate
  end

  def xtest_http
    http = CapyBrowser::RemoteCommunication::HTTP.http(@url)
    response = http.request( Net::HTTP::Get.new(@url))
    assert_equal 200, response.code.to_i
  end

  def xtest_https
    https = CapyBrowser::RemoteCommunication::HTTP.https(@https_url)
    response = https.request( Net::HTTP::Get.new(@https_url))
    assert_equal 200, response.code.to_i
  end

  def test_head
    response = CapyBrowser::RemoteCommunication::HTTP.head(@url,@headers)
    assert_equal 200, response.code.to_i
  end

  def test_get
    response = CapyBrowser::RemoteCommunication::HTTP.get(@url,@headers)
    assert_equal 200, response.code.to_i
  end

  def xtest_delete
    expected = "CapyBrowser::RemoteCommunication::HttpClient.request() failed ->\nCapyBrowser::RemoteCommunication::HttpClient.redirect() failed ->\nCapyBrowser::RemoteCommunication::HTTP error code was (500) for https://api.bbc.co.uk/sda/live/arts/artists/-titian"
    exception = assert_raises(RuntimeError){
      CapyBrowser::RemoteCommunication::HTTP.delete(@https_url,@headers)
    }
    assert_equal expected, exception.message
    response = CapyBrowser::RemoteCommunication::HTTP.delete(@url,@headers)
    assert_equal 200, response.code.to_i
  end

  def xtest_post
    assert_raises(RuntimeError){
      @headers.set_content_type ''
      CapyBrowser::RemoteCommunication::HTTP.post(@https_url,@headers,'   ')
    }

    assert_nothing_raised{
      @headers.set_content_type ' '
      CapyBrowser::RemoteCommunication::HTTP.post(@url,@headers,'')
    }

    @headers.set_content_type 'application/x-www-form-urlencoded'
    response = CapyBrowser::RemoteCommunication::HTTP.post(@url,@headers,{'foo' => 'bar'})
    assert_equal 200, response.code.to_i

    @headers.set_content_type 'application/xml'
    response = CapyBrowser::RemoteCommunication::HTTP.post(@url,@headers,'')
    assert_equal 200, response.code.to_i
  end

  def xtest_post_complains_when_no_content_type_set
    assert_raises(RuntimeError){
      @headers.set_content_type ''
      CapyBrowser::RemoteCommunication::HTTP.post(@https_url,@headers,'   ')
    }

    assert_nothing_raised{
      @headers.set_content_type ' '
      CapyBrowser::RemoteCommunication::HTTP.post(@url,@headers,'')
    }
  end

  def xtest_form_encoded_post
    assert_nothing_raised{
      @headers.set_content_type 'application/x-www-form-urlencoded'
      response = CapyBrowser::RemoteCommunication::HTTP.post(@url,@headers,{'foo' => 'bar'})
      assert_equal 200, response.code.to_i
    }
 end

  def xtest_inline_encoded_post
    assert_nothing_raised{
      @headers.set_content_type 'application/xml'
      response = CapyBrowser::RemoteCommunication::HTTP.post(@url,@headers,'')
      assert_equal 200, response.code.to_i
    }
  end

  def test_post_generate_500_errors_when_posting_to_a_endpoint_that_doesnst_support_the_post_verb
    @headers.set_content_type 'multipart/form-data, boundary=bbb'
    actual_error_message = assert_raises(RuntimeError){
      response = CapyBrowser::RemoteCommunication::HTTP.post(@https_url,@headers,{'foo' => 'bar', 'file'=> '/Users/me/.vimrc'})
    }
  end

  def test_encode_url_form_parameters
    request = mock("HttpRequest")
    request.expects(:set_form_data=).with([])
    @json_http_get = CapyBrowser::RemoteCommunication::HttpRequest.new(:get,@headers)
    @json_http_get.encode_url_form_parameters(request,[])
  end

  def xtest_put
    assert_raises(RuntimeError){
      CapyBrowser::RemoteCommunication::HTTP.put(@https_url,@headers)
    }
    response = CapyBrowser::RemoteCommunication::HTTP.put(@url,@headers,'')
    assert_equal 200, response.code.to_i
  end

  def xtest_verb
    exception = assert_raises(RuntimeError){
      CapyBrowser::RemoteCommunication::HttpRequest.new(:goo,@url,@headers)
    }
    expected = "CapyBrowser::RemoteCommunication::HttpRequest.initialize() failed ->\nCapyBrowser::RemoteCommunication::HttpRequest.method=() failed ->\nHTTP Verb('goo') not supported"
    assert_equal expected, exception.message
  end
end
