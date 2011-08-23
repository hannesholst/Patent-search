class Search
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
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
	count = 0
	resultList = Resultlist.new()
	@results.each do |result|
	  if (count < 5)
		newPatent = Patent.new(result[:id],result[:applicant],result[:priority_year],"","")
		resultList.list.push(newPatent)
	  end
	  count = count+1
	end
	return
  end
  
  def persisted?
    false
  end
end