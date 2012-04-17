require File.expand_path('../test_helper.rb',__FILE__)

class TestVersion < Test::Unit::TestCase
  def test_version_number
    assert_equal '0.0.2', CapyBrowser::VERSION
  end
end
