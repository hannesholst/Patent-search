class Pdf
	require 'prawn'
	
	def Generate()
		pdf = Prawn::Document.new(:page_size => "LETTER", :page_layout => :landscape)
		pdf.move_down 50
		pdf.text "Test! :)"
		pdf.render_file "testFile.pdf"
		return
	end
end
