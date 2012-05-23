require File.expand_path('../test_helper.rb',__FILE__)

class TestContentNegotiation < Test::Unit::TestCase

  def setup
    @negotiation = CapyBrowser::ContentNegotiation::Headers.new
    @json_negotiation = CapyBrowser::ContentNegotiation.json_content
    @urlencoded_negotiation = CapyBrowser::ContentNegotiation.urlencoded_content
  end

  def test_content_header_defaults
    assert_nil @negotiation.content_type
    assert_equal [], @negotiation.header_names
  end

  def test_content_headers_content_type
    @negotiation.set_content_type('application/json')
    assert_equal 'application/json', @negotiation.content_type
  end

  def test_content_headers_content_type_shows_in_header_names
    @negotiation.set_content_type('application/json')
    assert_equal ['content-type'], @negotiation.header_names
  end

  def test_content_negotiation_add_additional_headers
    @negotiation.add_additional_headers 'Accept' => 'application/json'
    @negotiation.add_additional_headers 'Accept' => 'application/xml'
    assert_equal ['accept'], @negotiation.header_names
    assert_equal ['application/json','application/xml'], @negotiation.get_fields('Accept')
   end

  def test_content_negotiation_json_content
    assert_equal ['accept','content-type'].sort, @json_negotiation.header_names.sort
    assert_equal 'application/json', @json_negotiation.content_type
    assert_equal ['application/json'], @json_negotiation.get_fields('Accept')
 end

 def test_content_negotiation_urlencoded_content
    assert_equal ['accept','content-type'].sort, @urlencoded_negotiation.header_names.sort
    assert_equal 'application/x-www-form-urlencoded',@urlencoded_negotiation.content_type
    assert_equal ['application/xml'], @urlencoded_negotiation.get_fields('Accept')
 end
end
