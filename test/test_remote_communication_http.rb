require File.expand_path('../test_helper.rb',__FILE__)

class TestRemoteCommunication_Http < Test::Unit::TestCase
  include HttpMocksResponses

  def setup
    @url = "http://bbcapi.thepcf.org.uk/actor/reference/-titian"
    @https_url = 'https://api.test.bbc.co.uk/sda/live/arts/artists/-titian'

    @json_headers = CapyBrowser::ContentNegotiation.json_content

    @titian = %q%{"item_count":1,"items":[{"id":"4755","reference":"-titian","name":"Titian","surname":"Titian","forename":null,"birth_year":"1488","death_year":"1576","life_display_dates":"c.1488\u20131576","active_start_date":null,"active_end_date":null,"dbpedia":"Titian","ulan_id":"500031075","nationality":"Italian","artist_website":null,"active_dates":null,"qualifier":null,"painting_count":"74","last_updated":"2011-05-20 10:06:39","deleted":"false"}]}%
    @http_200 = http_response
    @http_200.expects(:code).returns('200')
  end

  def test_head_json_request_200_response
    @http_200.expects(:body).returns(nil)
    response = CapyBrowser::RemoteCommunication::HTTP.head(@url,@json_headers)
    assert_equal @http_200.body,      response.body
    assert_equal @http_200.code.to_i, response.code.to_i
  end

  def test_get_json_request_200_response
    @http_200.expects(:body).returns(@titian)
    response = CapyBrowser::RemoteCommunication::HTTP.get(@url,@json_headers)
    assert_equal @http_200.body, response.body
    assert_equal @http_200.code.to_i, response.code.to_i
  end

  def test_put_json_request_200_response
    @http_200.expects(:body).returns(@titian)
    response = CapyBrowser::RemoteCommunication::HTTP.put(@url,@json_headers)
    assert_equal @http_200.code.to_i, response.code.to_i
    assert_equal @http_200.body, response.body
  end

  def test_post_json_request_200_response
    @http_200.expects(:body).returns(@titian)
    response = CapyBrowser::RemoteCommunication::HTTP.post(@url,@json_headers)
    assert_equal @http_200.code.to_i, response.code.to_i
    assert_equal @http_200.body, response.body
  end

  def test_delete_json_request_200_response
    @http_200.expects(:body).returns(@titian)
    response = CapyBrowser::RemoteCommunication::HTTP.delete(@url,@json_headers)
    assert_equal @http_200.code.to_i, response.code.to_i
    assert_equal @http_200.body, response.body
  end
end
