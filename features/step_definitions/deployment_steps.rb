Given /^I want to build a version of the gem$/ do
  @rake = CapyBrowser::Rake.rake("gems:build")
  @gem = CapyBrowser.gem
end

When /^The gem build process completes$/ do
  FileUtils.rm_rf @gem.gemfile_path.path
  @cmdline = @rake.invoke!
end

Then /^I should find a fresh build of the gem$/ do
  version = CapyBrowser::VERSION
  expect(@cmdline).to include("Successfully built RubyGem")
  expect(@cmdline).to include("Name: capybrowser")
  expect(@cmdline).to include("Version: #{version}")
  expect(@cmdline).to include("File: capybrowser-#{version}")
end
