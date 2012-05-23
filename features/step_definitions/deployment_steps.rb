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
  @cmdline.should include "Successfully built RubyGem"
  @cmdline.should include "Name: capybrowser"
  @cmdline.should include "Version: #{version}"
  @cmdline.should include "File: capybrowser-#{version}"
end
