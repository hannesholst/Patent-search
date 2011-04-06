require 'rubygems'
require 'rest_client'

url = 'http://ops.epo.org/2.6.2/rest-services/published-data/search?q=applicant%3DIBM'

response = RestClient.get(url)
 
puts response.body
