class Resultlist
	require 'prawn'
	
	attr_accessor :list
	@@list = Array.new
	
	def initialize()
		
	end
	
	def setArray(incomming)
		@@list.push(incomming)
	end
	
	#Method to create the pdf
	def Resultlist.createPdf()
		pdf = Prawn::Document.new(:page_size => "LETTER", :page_layout => :landscape)
		(0..4).each { |i|
			pdf.move_down 50
			pdf.text @@list[i].title, :align => :center, :size => 30, :style => :bold
			unless i==4
				pdf.start_new_page
			end
		}
		pdf.render_file "presentation.pdf"
		return
	end
end