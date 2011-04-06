When /^I run a simple query$/ do
  require 'rubygems'
  require 'rest_client'

  url = 'http://ops.epo.org/2.6.2/rest-services/published-data/search?q=applicant%3DIBM'

  @response = RestClient.get(url)

end

When /^I should see a result$/ do
  @response.code.should == 200
  @response.body.should_not == nil
end