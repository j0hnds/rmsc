header = [ 'Name', 'Store Name', 'Store Address', 'City', 'State', 'ZIP' ]

# pdf.text "Hello"
pdf.table([ header ] + @buyer_list,
         :header => true,
         :width => pdf.bounds.width,
         :cell_style => { :size => 10 }) do
  row(0).style(:font_style => :bold, :background_color => 'cccccc')
end