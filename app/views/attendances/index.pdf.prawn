header = [ 'Buyer', 'Store Name', 'Address', 'City', 'State', 'ZIP', 'Phone' ]

pdf.table([ header ] + @buyer_rows,
         :header => true,
         :width => pdf.bounds.width,
         :cell_style => { :size => 10 }) do
  row(0).style(:font_style => :bold, :background_color => 'cccccc')
end