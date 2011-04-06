Feature: Search query
   In order to lookup for patents
   As a user
   I want to input a search string and get a list of patents

  Scenario: Simple search
    Given I am on the homepage
    When I fill in "search_query" with "Ericsson"
    And I press "Search"
    
    #Check for general information about the query

    #Test for hits
    Then I should see "About"

    #Test for response time
    Then I should see "seconds"

    #Test for query string
    Then I should see "Results for"

    #Test for Range
    Then I should see "to"

    #Check information about publications
    Then I should see "Document ID"
    Then I should see "Applicant"
    Then I should see "Priority Date"
    Then I should see "First Page Image"

  Scenario: Searching for an invalid query statement
    Given I am on the homepage
    When I fill in "search_query" with "test this invalid"

  Scenario: Searching for a query string that requires escaping
    Given I am on the homepage
    When I fill in "search_query" with "applicant=IBM"

  #This is the desired identifier to be used for a patent document
  Scenario: The search results have a publication with of type epodoc

  Scenario: The search results have a publication with two ID numbers

  Scenario: The search results have a publication with of type docdb

  Scenario: The search result have only one element returned
