require File.expand_path('../test_helper', __FILE__)

class TestURL < Minitest::Test
  def setup
    @pcf_http_url  = "http://bbcapi.thepcf.org.uk/actor/reference/-titian"
    @bbc_http_url  = 'http://api.test.bbc.co.uk/sda/live/arts/artists/-titian'
    @bbc_https_url = 'https://api.test.bbc.co.uk/sda/live/arts/artists/-titian'
    @bbc_http_auth_url  = "http://foo:bar@api.test.bbc.co.uk/sda/live/arts/artists/-titian"
    @bbc_https_auth_url  = "https://foo:bar@api.test.bbc.co.uk/sda/live/arts/artists/-titian"
    @my_cert = '/Users/me/Documents/media/certificates/personal-cert.pem'
  end

  def test_creating_as_http_url
    @url = CapyBrowser::URL.http @bbc_https_url
    assert_equal @bbc_http_url, @url.to_s
    assert_false @url.https?
    @url.user = 'foo:bar'
    assert_equal @bbc_http_auth_url, @url.to_http_uri.to_s
  end

  def test_creating_as_https_url
    @url = CapyBrowser::URL.https @bbc_http_url
    assert_equal @bbc_https_url, @url.to_s
    assert_true @url.https?
    @url.user = 'foo:bar'
    assert_equal @bbc_https_auth_url, @url.to_https_uri.to_s
  end

  def test_relative_urls
    url = CapyBrowser::URL.new('http://foo.bbc.co.uk')
    url = url.relative_to '/hotmail'
    assert_equal("http://foo.bbc.co.uk/hotmail",url.to_s)
    assert_equal("/hotmail",url.request_uri)
    url = url.relative_to '/gmail'
    assert_equal("http://foo.bbc.co.uk/gmail",url.to_s)
    assert_equal("/gmail",url.request_uri)
    url = url.relative_to 'http://foo.bbc.co.uk/hotmail'
    assert_equal("http://foo.bbc.co.uk/hotmail",url.to_s)
  end

  def test_problem_case
    url = CapyBrowser::URL.new(@pcf_http_url.to_s)
    assert_equal @pcf_http_url, url.to_s
    assert_equal URI.parse(@pcf_http_url).scheme, url.scheme
    assert_equal URI.parse(@pcf_http_url).host, url.host
    assert_equal URI.parse(@pcf_http_url).port, url.port
    assert_equal URI.parse(@pcf_http_url).request_uri, url.request_uri
    assert_equal URI.parse(@pcf_http_url).relative?, url.relative?
    assert_equal URI.parse(@pcf_http_url).absolute?, url.absolute?
  end

  def test_raises_on_bad_urls
    exception = assert_raises(RuntimeError){
      url = CapyBrowser::URL.new(':http:/>sfoo')
    }
    assert_equal "CapyBrowser::URL.initialize() failed ->\nParsing '\":http:/>sfoo\"' as URL failed", exception.message
  end
end
