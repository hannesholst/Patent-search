class Resultlist
	require 'prawn'
	@@list = Array.new(5)
	
	#Default constructor
	def initialize()
		
	end
	
	#Method to create the pdf
	def Resultlist.createPdf()
		pdf = Prawn::Document.new(:page_size => "LETTER", :page_layout => :landscape)
		
		#This prints the title of the patent
		pdf.move_down 50
		pdf.text @@list[0].title, :align => :center, :size => 30, :style => :bold

		pdf.render_file "multiplePages.pdf"
	end
end