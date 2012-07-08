header = %w{ Line Exhibitor Phone }

pdf.table([header] + @show_lines,
          :header => true,
          :column_widths => {
            0 => pdf.bounds.width * 0.5,
            1 => pdf.bounds.width * 0.30,
            2 => pdf.bounds.width * 0.20 },
          :row_colors => [ 'ffffff', 'eeeeee' ],
          :cell_style => { :size => 10 },
          :width => pdf.bounds.width) do
  row(0).style(:font_style => :bold, :background_color => 'cccccc')
end
