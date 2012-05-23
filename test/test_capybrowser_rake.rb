require File.expand_path('../test_helper.rb',__FILE__)

class TestCapyBrowser < Test::Unit::TestCase
  def test_rake_should_invoke_the_executable
    mock_executable = mock("FakeExecutable")
    mock_executable.expects(:invoke!).times(1)
    CapyBrowser::Rake::Executable.expects(:rake).times(1).returns(mock_executable)
    CapyBrowser::Rake.rake.invoke!
  end

  def test_cucumber_should_invoke_the_executable
    mock_rcov = mock("FakeRcov")
    CapyBrowser::Rake::Executable.expects(:rcov).times(1).returns(mock_rcov)

    mock_cucumber = mock("FakeRcov")
    mock_cucumber.expects(:invoke!).times(1)
    CapyBrowser::Rake::Executable.expects(:cucumber).times(1).returns(mock_cucumber)

    CapyBrowser::Rake.cucumber.invoke!
  end
end
