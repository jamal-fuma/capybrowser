@complete @coverage
Feature: Coverage Reporting
    As a Developer
    I want to know how much code is covered by tests

Scenario: Coverage reports are generated automatically for units tests
    Given I want see the coverage levels of the current codebase
    When I complete a test build
    Then I should see "Coverage Information" in the report

Scenario: Coverage reports are generated automatically for acceptance tests
    Given I want see the acceptance test coverage levels of the current codebase
    When I complete a acceptance test build
    Then I should see "Cucumber" clearly displayed within the report
