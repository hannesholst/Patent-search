class Search
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  require 'Patent'
  require 'Resultlist'
  require 'Pdf'

  attr_accessor :query,
                :last_query,:range,
                :range_start, :range_end,
                :response, :hits, :response_time,
                :results

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def createList
	resultList = Resultlist.new
	count = 0
	results.each do |result|
	  if (count < 5)
		newPatent = Patent.new(result[:id],result[:applicant],result[:priority_year],"","")
		resultList.push(newPatent)
	  end
	  count = count+1
	end
	return
  end
  
  def createPdf
    Pdf.Generate
    return
  end
  
  def persisted?
    false
  end
end