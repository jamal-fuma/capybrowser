@complete @deployment
Feature: Deployment
    As a Developer
    I want to package the source code as a gem
    I want to increment the version when code is changed

Scenario: Gem is packaged successfully
    Given I want to build a version of the gem
    When The gem build process completes
    Then I should find a fresh build of the gem
