require File.expand_path('../test_helper.rb',__FILE__)

class TestCertificateAuthentication <  Test::Unit::TestCase
  def setup
    @my_cert = '/Users/me/Documents/media/certificates/personal-cert.pem'
    data = File.read(@my_cert)
    @cert = OpenSSL::X509::Certificate.new data
    @key  = OpenSSL::PKey::RSA.new(data,nil)
    OpenSSL::X509::Certificate.stubs(:new).returns(@cert)
    OpenSSL::PKey::RSA.stubs(:new).returns(@key)
  end

  def teardown
    OpenSSL::X509::Certificate.unstub(:new)
    OpenSSL::PKey::RSA.unstub(:new)
  end

  def test_certificate_strategy_impl_unauthenticated
    ssl_certificate_authenticate_failure CapyBrowser::CertificateAuthentication::CertificateStrategyImpl.unauthenticated('')
    ssl_certificate_authenticate_failure CapyBrowser::CertificateAuthentication::CertificateStrategyImpl.unauthenticated(nil)
  end

  # this is a belt and braces test, we don't expect an exception here in normal use
  def test_correct_exception_raised_in_response_to_failure
     CapyBrowser::CertificateAuthentication::CertificateStrategyImpl.expects(:new).raises(RuntimeError,"real reason")
     exception = assert_raises(RuntimeError){
        CapyBrowser::CertificateAuthentication::CertificateStrategyImpl.unauthenticated('foo')
     }
     assert_equal "CapyBrowser::CertificateAuthentication::CertificateStrategyImpl.unauthenticated() failed ->", exception.message.split("\n").first
     assert_equal "real reason", exception.message.split("\n").last
  end

  def test_certificate_authentication_failure
    ssl_certificate_authenticate_failure CapyBrowser::CertificateAuthentication.build('')
    ssl_certificate_authenticate_failure CapyBrowser::CertificateAuthentication.build(nil)
  end


  def test_ssl_certificate_authenticate_success
    ssl_certificate_authenticate_success(
      CapyBrowser::CertificateAuthentication::SSLCertificate.new @my_cert
    )
    ssl_certificate_authenticate_success(
      CapyBrowser::CertificateAuthentication::CertificateStrategyImpl.authenticated(@my_cert)
    )
    ssl_certificate_authenticate_success(
      CapyBrowser::CertificateAuthentication.build(@my_cert)
    )
  end

  def ssl_certificate_authenticate_success(ssl_certificate)
    http = mock("http")
    http.expects(:verify_mode=).once.with(OpenSSL::SSL::VERIFY_NONE)
    http.expects(:cert=).once
    http.expects(:key=).once
    http.expects(:use_ssl).once.returns(true)
    assert_equal http,ssl_certificate.authenticate(http)
  end

  def ssl_certificate_authenticate_failure(ssl_certificate)
    http = mock("http")
    http.expects(:verify_mode=).never
    http.expects(:cert=).never
    http.expects(:key=).never
    assert_equal http,ssl_certificate.authenticate(http)
  end
end
