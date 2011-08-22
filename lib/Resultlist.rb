class Resultlist
	#Declare getters/setters for resultlist
	attr_accessor :resultlist
	
	#Default constructor for variable number of patents
	def initialize()
		@@resultlist = Array.new(5)
	end
	
end