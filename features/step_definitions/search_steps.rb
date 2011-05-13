When /^I run a simple query$/ do
  require 'rubygems'
  require 'rest_client'

  VCR.use_cassette("simple_test", :record => :once) do
    url = 'http://ops.epo.org/2.6.2/rest-services/published-data/search?q=applicant%3DIBM'
    @response = RestClient.get(url)
  end
end

When /^I should see a result$/ do
  @response.code.should == 200
  @response.body.should_not == nil
end

When /^I perform the search pressing the Search button$/ do
  unless defined? @last_input_text
    @last_input_text = "missing_query_string"
  end
  fixture_name = @last_input_text.tr('"= ', '_')
  VCR.use_cassette(fixture_name, :record => :once) do
    When 'I press "Search"'
  end
end