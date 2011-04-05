Feature: Search query
   In order to lookup for patents
   As a user
   I want to input a search string and get a list of patents

  Scenario: Simple search
    Given I am on the homepage
    When I fill in "search_query" with "test patent number"
    And I press "Search"
    Then I should see "About"
    Then I should see "seconds"
    Then I should see "Results for"
    Then I should see "Document ID"
    Then I should see "Applicant"
    Then I should see "Priority Date"
    Then I should see "First Page Image"