column_gutter = 0 # 12
row_gutter = 0 # 10
cell_width = (pdf.bounds.width - (1 * column_gutter))  / 2
cell_height = (pdf.bounds.height - (2 * row_gutter)) / 3

page_number = 0
@registrations.each_slice(6) do | page_worth |
  page_number += 1
  pdf.start_new_page unless page_number == 1

  # Build up the page grid
  upper_lefts = (0..5).collect do | idx |
    col = idx % 2
    row = idx / 2
    [ pdf.bounds.left + ((col * cell_width) + (col * column_gutter)),
      pdf.bounds.top  - ((row * cell_height) + (row * row_gutter)) ]
  end

  page_worth.each_with_index do | registration, idx |
    exhibitor = registration.exhibitor
    col = idx % 2
    row = idx / 2
    pdf.bounding_box(upper_lefts[idx], :width => cell_width, :height => cell_height) do
      pdf.move_down 13.5
      pdf.indent 13.5 do
        pdf.text("#{exhibitor.first_name} #{exhibitor.last_name}", :size => 10)
        pdf.text(exhibitor_rooms(registration.rooms), :size => 10)
        pdf.text(registration.lines.collect(&:line).join(','), :size => 10)
      end
      pdf.stroke_bounds
    end
  end
end
