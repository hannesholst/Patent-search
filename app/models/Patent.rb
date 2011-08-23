class Patent
	#Declare getters/setters for each item
	attr_accessor :title,
				  :priorityYear, 
				  :applicant, 
				  :figure, 
				  :link
	
	#Default constructor
	def initialize(title, priorityYear, applicant, figure, link)
		@title = title
		@priorityYear = priorityYear
		@applicant = applicant
		@figure = figure
		@link = link	
	end
end