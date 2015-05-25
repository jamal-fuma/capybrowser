require File.expand_path('../test_helper.rb',__FILE__)

class TestRemoteCommunication_HttpRequests_JSON < Minitest::Test
  include HttpMocksResponses

  def setup
    @url = "http://localhost:3000"
    # titian seems to have disappeared -- @url = "http://bbcapi.thepcf.org.uk/actor/reference/-titian"
    # @titian = %q%{"item_count":1,"items":[{"id":"4755","reference":"-titian","name":"Titian","surname":"Titian","forename":null,"birth_year":"1488","death_year":"1576","life_display_dates":"c.1488\u20131576","active_start_date":null,"active_end_date":null,"dbpedia":"Titian","ulan_id":"500031075","nationality":"Italian","artist_website":null,"active_dates":null,"qualifier":null,"painting_count":"74","last_updated":"2011-05-20 10:06:39","deleted":"false"}]}%
    @https_url = 'https://localhost:3000'

    @json_headers = CapyBrowser::ContentNegotiation.json_content
    @json_http_get = CapyBrowser::RemoteCommunication::HttpRequest.new(:get,@json_headers)
    @json_http_head = CapyBrowser::RemoteCommunication::HttpRequest.new(:head,@json_headers)
    @json_http_put = CapyBrowser::RemoteCommunication::HttpRequest.new(:put,@json_headers)
    @json_http_post = CapyBrowser::RemoteCommunication::HttpRequest.new(:post,@json_headers)
    @json_http_delete = CapyBrowser::RemoteCommunication::HttpRequest.new(:delete,@json_headers)
    @wilson = %q[{"item_count":1,"items":[{"id":"6","reference":"wilson-a-","name":"Wilson_A.","surname":"Wilson","forename":"A.","birth_year":null,"death_year":null,"life_display_dates":null,"active_start_date":null,"active_end_date":null,"dbpedia":null,"ulan_id":null,"nationality":null,"artist_website":null,"active_dates":null,"qualifier":null,"painting_count":"1","last_updated":"2011-03-19 17:24:33","deleted":"false"}]}]
    @http_200 = http_response
  end

  def test_head_json_request_200_response
    @http_200.expects(:body).returns(nil)
    @http_200.expects(:code).returns('200')
    response = @json_http_head.request(@url)
    assert_equal @http_200.body, response.body
    assert_equal @http_200.code.to_i, response.code.to_i
  end

  def test_get_json_request_200_response
    @http_200.expects(:body).returns(@wilson)
    @http_200.expects(:code).returns('200')
    response = @json_http_get.request(@url)
    assert_equal @http_200.body, response.body
    assert_equal @http_200.code.to_i, response.code.to_i
  end

  def test_put_json_request_200_response
    @http_200.expects(:body).returns(@wilson)
    @http_200.expects(:code).returns('200')
    response = @json_http_put.request(@url)
    assert_equal @http_200.code.to_i, response.code.to_i
    assert_equal @http_200.body, response.body
  end

  def test_post_json_request_200_response
    @http_200.expects(:body).returns(@wilson)
    @http_200.expects(:code).returns('200')
    response = @json_http_post.request(@url)
    assert_equal @http_200.code.to_i, response.code.to_i
    assert_equal @http_200.body, response.body
  end

  def xtest_delete_json_request_200_response
    @http_200.expects(:body).returns(@wilson)
    @http_200.expects(:code).returns('200')
    response = @json_http_delete.request(@url)
    assert_equal @http_200.code.to_i, response.code.to_i
    assert_equal @http_200.body, response.body
  end
end
