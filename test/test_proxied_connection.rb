
require File.expand_path('../test_helper.rb',__FILE__)

class TestProxiedConnection <  Test::Unit::TestCase
  def setup
  end
  def test_indirect
    http = mock("http")
    http.expects(:use_ssl=).once.with(false)
    Net::HTTP.stubs(:new).returns(http)
    @proxy_path = 'http://www-cache.reith.bbc.co.uk'
    uri = 'http://www.google.co.uk'
    proxy = CapyBrowser::ProxiedConnection::ProxyStrategyImpl.proxied_connection(@proxy_path)
    proxy.http(uri)
  end

  def test_direct
    backend = CapyBrowser::ProxiedConnection::NetHttpBackend.new
    assert_respond_to backend,:direct
    assert_respond_to backend,:indirect
    CapyBrowser::ProxiedConnection::ProxyStrategyImpl.stubs(:new).raises(RuntimeError)
    assert_raises(RuntimeError){
      proxy = CapyBrowser::ProxiedConnection.build(@proxy_path)
    }
  end
end
