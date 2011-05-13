Feature: Search query
   In order to lookup for patents
   As a user
   I want to input a search string and get a list of patents

  Background:
    Given I am on the homepage

  Scenario: Simple search
    When I fill in "search_query" with "Ericsson"
#    And I press "Search"
    And I perform the search pressing the Search button

    #Check for general information about the query

    #Test for hits
    Then I should see "About"

    #Test for response time
    Then I should see "seconds"

    #Test for query string
    Then I should see "results for"

    #Test for Range
    Then I should see "to"

    #Check information about publications
    Then I should see "Document ID"
    Then I should see "Applicant"
    Then I should see "Priority Date"
    Then I should see "First Page Image"

  Scenario: Searching for an invalid query statement
    When I fill in "search_query" with "test this invalid"
    And I perform the search pressing the Search button
    Then I should see "Invalid Common Query Language Statement"

  Scenario: Searching for a query string that requires escaping
    When I fill in "search_query" with "applicant=IBM"
    And I perform the search pressing the Search button
    Then I should see "100000 results"

  Scenario: Searching document without Priorty date
    When I fill in "search_query" with "2011084712"
    And I perform the search pressing the Search button
    Then I should see "US 2011084712 A1"
    Then I should see "Not found"

  Scenario: Searching document without Applicant date
    When I fill in "search_query" with "3023737"
    And I perform the search pressing the Search button
    Then I should see "EURATOM [LU]"
    Then I should see "Not found"

  Scenario: The search result have only one element returned
    When I fill in "search_query" with "NO790800A"
    And I perform the search pressing the Search button
    Then I should see "NO 790800 A"

  Scenario: Empty Search
      And I perform the search pressing the Search button
      Then I should see "Empty Search"

  #This is the desired identifier to be used for a patent document
  Scenario: The search results have a publication with of type epodoc

  Scenario: The search results have a publication with two ID numbers

  Scenario: The search results have a publication with of type docdb


  Scenario: Testing Priority Claim
    When I fill in "search_query" with "US7935613B2"
    And I perform the search pressing the Search button
    Then I should see "20031216"

  Scenario: Testing Priority Claim
    When I fill in "search_query" with "us2011088961"
    And I perform the search pressing the Search button
    Then I should see "20091019"
