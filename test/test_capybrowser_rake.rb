require File.expand_path('../test_helper.rb',__FILE__)

class TestCapyBrowser < Minitest::Test
  def test_rake_should_invoke_the_executable
    mock_executable = mock("FakeExecutable")
    mock_executable.expects(:invoke!).times(1)
    CapyBrowser::Rake::Executable.expects(:rake).times(1).returns(mock_executable)
    CapyBrowser::Rake.rake.invoke!
  end

  def test_cucumber_should_invoke_the_executable
    mock_cucumber = mock("FakeCuke")
    mock_cucumber.expects(:invoke!).times(1)
    CapyBrowser::Rake::Executable.expects(:cucumber).times(1).returns(mock_cucumber)

    CapyBrowser::Rake.cucumber.invoke!
  end
end
