require File.expand_path('../test_helper.rb',__FILE__)

class TestVersion < Minitest::Test
  def test_version_number
    assert_equal '0.0.4', CapyBrowser::VERSION
  end
end
