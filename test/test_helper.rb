require 'test/unit'
require 'capybrowser'
require 'mocha'
require 'ci/reporter/rake/test_unit_loader'

module HttpMocksResponses
  def http_response(opts={})
    mock = mock('Net::HTTPResponse')
    # from "http://bbcapi.thepcf.org.uk/actor/reference/-titian"
    titian = %q%{"item_count":1,"items":[{"id":"4755","reference":"-titian","name":"Titian","surname":"Titian","forename":null,"birth_year":"1488","death_year":"1576","life_display_dates":"c.1488\u20131576","active_start_date":null,"active_end_date":null,"dbpedia":"Titian","ulan_id":"500031075","nationality":"Italian","artist_website":null,"active_dates":null,"qualifier":null,"painting_count":"74","last_updated":"2011-05-20 10:06:39","deleted":"false"}]}%
    defaults = {
      :code => '200',
      :message => "OK",
      :content_type => 'application/json',
      :body => titian
    }
    mock.stubs( defaults.merge(opts) )
  end

  def http_redirect(location,code)
    response = http_response :code => code.to_s, :message => "#{code.to_s} Redirect"
    response.expects(:code).returns(code.to_s)
    response.expects(:[]).with('location').returns(location)
    response.stubs(:body).returns("#{code.to_s} Redirect")
    response
  end

  def http_error(code)
    response = http_response :code => code.to_s, :message => "#{code.to_s} Error"
    response.stubs(:code).returns(code.to_s)
    response.stubs(:body).returns("#{code.to_s} Error")
    response
  end

  def http_301_redirect(location)
    http_redirect(location,301)
  end

  def http_302_redirect(location)
    http_redirect(location,302)
  end

  def http_303_redirect(location)
    http_redirect(location,303)
  end

  def http_500_error
    http_error(500)
  end

  def http_401_error
    http_error(401)
  end

  def stub_get_response(*response)
    CapyBrowser::RemoteCommunication::HttpRequest.any_instance.stubs(:request).returns(*response)
 #   Net::HTTP.expects(:get_response).returns(response)
  end

  def unstub_get_response
    CapyBrowser::RemoteCommunication::HttpRequest.unstub(:request)
    #Net::HTTP.unstub(:get_response)
  end
end

ENV['CERT'] = '/Users/me/Documents/media/certificates/personal-cert.pem'
ENV["CI_REPORTS"] = CapyBrowser::Rake::RelativePath.new('tmp/doc/tests/junit').path

