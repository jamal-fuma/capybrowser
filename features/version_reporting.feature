@complete @version
Feature: Version Reporting
    As a Developer
    I want to know which version of the gem is installed

Scenario: Version is available as a module constant
    Given I have installed version "0.0.2" of the gem
    When I check for the version
    Then I should see the correct version is reported
