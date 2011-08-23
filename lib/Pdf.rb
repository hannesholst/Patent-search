class Pdf
	require 'prawn'
	
	#Static method to generate pdf
	def Pdf.Generate()
		pdf = Prawn::Document.new(:page_size => "LETTER", :page_layout => :landscape)
		pdf.move_down 50
		pdf.text "Dit is een test!"
		pdf.render_file "testFile.pdf"
		return
	end
end
