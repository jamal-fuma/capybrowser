require File.expand_path('../test_helper.rb',__FILE__)

class TestCertificateAuthentication_SSLCertificate <  Minitest::Test
  def setup
    @my_cert = '/Users/me/Documents/media/certificates/personal-cert.pem'
    @ssl_certificate = CapyBrowser::CertificateAuthentication::SSLCertificate.new(@my_cert)
  end

  def teardown
    OpenSSL::X509::Certificate.unstub(:new)
    OpenSSL::PKey::RSA.unstub(:new)
  end

  def test_to_hash
    assert_equal({:cer => @my_cert, :key=>@my_cert},@ssl_certificate.to_hash)
  end

  def test_responds_to_cert
    assert_respond_to @ssl_certificate, :cert
    assert_nothing_raised {
      @ssl_certificate.cert
    }
    assert_nothing_raised {
      @ssl_certificate = 
        CapyBrowser::CertificateAuthentication::SSLCertificate.new ''
    }
    assert_raises(RuntimeError) {
      @ssl_certificate.cert
    }
  end

  def test_responds_to_key
    assert_nothing_raised {
      @ssl_certificate.key
    }
    assert_nothing_raised {
      @ssl_certificate = 
        CapyBrowser::CertificateAuthentication::SSLCertificate.new ''
    }
    assert_raises(RuntimeError) {
      @ssl_certificate.key
    }
  end

  def test_default_verify_mode
    assert_equal OpenSSL::SSL::VERIFY_NONE, @ssl_certificate.verify_mode
  end

  def test_authenticate_success
    data = File.read(@my_cert)
    cert = OpenSSL::X509::Certificate.new data
    key  = OpenSSL::PKey::RSA.new(data,nil)

    http = mock("http")
    http.stubs(:use_ssl).once.returns(true)
    http.expects(:verify_mode=).once.with(OpenSSL::SSL::VERIFY_NONE)
    http.expects(:cert=).once.with(cert)
    http.expects(:key=).once.with(key)

    OpenSSL::X509::Certificate.stubs(:new).returns(cert)
    OpenSSL::PKey::RSA.stubs(:new).returns(key)
    assert_equal http, @ssl_certificate.authenticate(http)
  end

  def test_authenticate_failure
    http = mock("http")
    http.expects(:verify_mode=).never
    http.expects(:cert=).never
    http.expects(:key=).never
    assert_nothing_raised{
      @ssl_certificate = 
        CapyBrowser::CertificateAuthentication::SSLCertificate.new ''
    }
    assert_raises(RuntimeError){
        @ssl_certificate.authenticate(http)
    }
  end
end
