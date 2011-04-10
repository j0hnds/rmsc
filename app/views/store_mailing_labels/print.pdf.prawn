column_gutter = 12
row_gutter = 10
cell_width = (pdf.bounds.width - (2 * column_gutter))  / 3
cell_height = (pdf.bounds.height - (9 * row_gutter)) / 10

page_number = 0
@stores.each_slice(30) do | page_worth |
  page_number += 1
  pdf.start_new_page unless page_number == 1

  # Build up the page grid
  upper_lefts = (0..29).collect do | idx |
    col = idx % 3
    row = idx / 3
    [ pdf.bounds.left + ((col * cell_width) + (col * column_gutter)),
      pdf.bounds.top  - ((row * cell_height) + (row * row_gutter)) ]
  end

  page_worth.each_with_index do | store, idx |
    col = idx % 3
    row = idx / 3
    pdf.bounding_box(upper_lefts[idx], :width => cell_width, :height => cell_height) do
      pdf.text(store.name, :size => 10)
      pdf.text(store.address, :size => 10)
      pdf.text("#{store.city}, #{store.state}  #{store.postal_code}", :size => 10)
      pdf.stroke_bounds
    end
  end
end