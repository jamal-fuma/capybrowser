require 'test/unit'

require File.expand_path('../../tasks/task_helper',__FILE__)

class TestTaskHelper < Test::Unit::TestCase
  def test_env_tests_returns_empty_string_when_env_is_unset
    ENV['TESTS'] = nil
    assert_empty env_tests
  end

  def test_env_tests_does_not_returns_empty_string_when_env_is_set
    ENV['TESTS'] = 'foo'
    assert_not_empty env_tests
    assert_equal 'foo', env_tests
  end

  def test_test_sources_returns_defaults_when_env_is_unset
    ENV['TESTS'] = nil
    assert_equal 'test/test_*.rb', test_sources
  end

  def test_test_sources_does_not_returns_empty_string_when_env_is_set
    ENV['TESTS'] = 'foo'
    assert_not_empty test_sources
    assert_equal 'foo', test_sources
  end

  def test_rcov_options
    expected = "--aggregate tmp/doc/coverage/coverage.data --text-summary --html -o tmp/doc/coverage --exclude gems"
    assert_equal expected, rcov_options
  end

  def test_rcov_arguments
    expected = "--aggregate tmp/doc/coverage/coverage.data --text-summary --html -o tmp/doc/coverage --exclude gems"
    assert_equal "#{expected} ", rcov_arguments
    assert_equal "#{expected} foo", rcov_arguments('foo')
  end

  def test_rcov_cmdline
    expected = "bundle exec rcov --aggregate tmp/doc/coverage/coverage.data --text-summary --html -o tmp/doc/coverage --exclude gems test/test_*.rb"
    assert_equal expected, rcov_cmdline
  end
end
