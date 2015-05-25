Given /^I have installed version "([^"]+)" of the gem$/ do |version|
  @expected_version = version
end

When /^I check for the version$/ do
  @actual_version   = CapyBrowser::VERSION
end

Then /^I should see the correct version is reported$/ do
  expect(@actual_version).to be == @expected_version
end
