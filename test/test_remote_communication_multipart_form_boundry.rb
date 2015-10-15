require File.expand_path('../test_helper.rb',__FILE__)

class TestRemoteCommunication_MultiPartFormBoundry < Minitest::Test
  include HttpMocksResponses

  def setup
    @url = "http://bbcapi.thepcf.org.uk/actor/reference/-titian"
    @https_url = 'https://api.test.bbc.co.uk/sda/live/arts/artists/-titian'

    @json_headers = CapyBrowser::ContentNegotiation.json_content
    @json_http_get = CapyBrowser::RemoteCommunication::HttpRequest.new(:get,@json_headers)
    @json_http_head = CapyBrowser::RemoteCommunication::HttpRequest.new(:head,@json_headers)
    @json_http_put = CapyBrowser::RemoteCommunication::HttpRequest.new(:put,@json_headers)
    @json_http_post = CapyBrowser::RemoteCommunication::HttpRequest.new(:post,@json_headers)
    @json_http_delete = CapyBrowser::RemoteCommunication::HttpRequest.new(:delete,@json_headers)

    @titian = %q%{"item_count":1,"items":[{"id":"4755","reference":"-titian","name":"Titian","surname":"Titian","forename":null,"birth_year":"1488","death_year":"1576","life_display_dates":"c.1488\u20131576","active_start_date":null,"active_end_date":null,"dbpedia":"Titian","ulan_id":"500031075","nationality":"Italian","artist_website":null,"active_dates":null,"qualifier":null,"painting_count":"74","last_updated":"2011-05-20 10:06:39","deleted":"false"}]}%
    CapyBrowser::RemoteCommunication::MultipartFormBoundry.any_instance.stubs(:generate).returns("foo")
    @boundry = CapyBrowser::RemoteCommunication::MultipartFormBoundry.new
  end

  def test_boundry
    assert_equal "multipart/form-data, boundary=foo", @boundry.to_multipart_form_content_type
    assert_equal "\r\n--foo--\r\n",  @boundry.to_multipart_form([])
  end
  def test_form
    form = CapyBrowser::RemoteCommunication::MultipartForm.new({'foo' => 'bar', 'file' => '/Users/me/.vimrc'})
    request = mock("HttpRequest")
    request.expects(:body=)
    request.expects(:set_content_type)
    form.encode(request)
  end
end
