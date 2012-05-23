Given /^I want see the coverage levels of the current codebase$/ do
  @rcov = CapyBrowser::Rake.rake("tests")
  @report = CapyBrowser::Rake::RelativePath.new('tmp/doc/coverage/index.html')
end

When /^I complete a test build$/ do
  @output = @rcov.invoke!
end

Then /^I should see "(.*?)" in the report$/ do |coverage_report_title|
  @report.exists? == true
  File.read(@report.path).should include coverage_report_title
  @report = nil
end

Given /^I want see the acceptance test coverage levels of the current codebase$/ do
  @cucumber = CapyBrowser::Rake.rake '"features:local:http:test[-t @version]" --trace'
  @report = CapyBrowser::Rake::RelativePath.new('tmp/doc/cucumber/html/report.html')
end

When /^I complete a acceptance test build$/ do
  @cucumber.invoke!
end

Then /^I should see "(.*?)" clearly displayed within the report$/ do |coverage_report_title|
  @report.exists? == true
  File.read(@report.path).should include coverage_report_title
end
