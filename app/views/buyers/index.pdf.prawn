header = [ 'Name', 'Store Name', 'Store Address', 'City', 'State', 'ZIP' ]

# pdf.text "Hello"
pdf.table([ header ] + @buyer_list,
         :header => true,
         :width => pdf.bounds.width,
         :cell_style => { :size => 12 }) do
  row(0).style(:style => :bold, :background_color => 'cccccc')
end