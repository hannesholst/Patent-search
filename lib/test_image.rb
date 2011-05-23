require 'rubygems'
require 'rest_client'
require 'crack'

patent_number = ARGV[0]
#patent_number = 'EP.1000000.A1'
puts "Patent number is: #{patent_number}"
url = "http://ops.epo.org/2.6.2/rest-services/published-data/publication/docdb/#{patent_number}/images"

#test patents
#1 US.2011074386.A1
#2 EP.1000000.A1
#3 GB.343434.A

response = RestClient.get(url)

doc = Crack::XML.parse (response)

#@search.last_query = @doc['ops:world_patent_data']['ops:biblio_search']['ops:query']

puts response.body
puts "----------------------------------------------------------------------------"
puts doc.inspect

#Page 43 describes the response structure
image_array = doc["ops:world_patent_data"]["ops:document_inquiry"]["ops:inquiry_result"]["ops:document_instance"]

puts "Image Array is:"
puts image_array.inspect
puts "Image Array length: #{image_array.size}"

puts "Image Element types:"
#Page 48 shows types as: Drawing, FullDocument or FirstPageClipping
image_element_link = nil
image_array.each do |image_element|
  image_element_type = image_element["desc"]
  puts image_element_type
  if image_element_type == "FirstPageClipping"
    image_element_link = image_element["link"]
    puts "Found FirstPage image at: #{image_element_link}"
  end
end

if image_element_link
  url_for_images = "http://ops.epo.org/2.6.2/rest-services/"

  #This information should be retrieved from the response, here we use a default value
  name_extension = ".pdf"
  range_selection = "?range=1"

  url = url_for_images + image_element_link + name_extension + range_selection

  puts "Retrieving image with call to: #{url}"
  response = RestClient.get(url)
  puts "Image returned"
  #puts response.class
  #puts response.inspect
  File.open('firstpage.pdf', 'w') {|f| f.write(response) }
end