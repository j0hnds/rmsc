require 'prawn'
require 'prawn/layout'

avery_5160_margin = 16 # 0.21975in * 72ppi = 15.82

Prawn::Document.generate('labels.pdf', :left_margin => avery_5160_margin, :right_margin => avery_5160_margin) do |p|
  
  p.define_grid(:columns => 3, :rows => 10, :column_gutter => 12, :row_gutter => 10)
  p.grid.rows.times do |i|
    p.grid.columns.times do |j|
      b = p.grid(i,j)
      p.bounding_box b.top_left, :width => b.width, :height => b.height do
        p.indent(7) do
          p.move_down 7
          p.text 'John McCaffrey'
          p.text 'Pathfinder Development'
          p.text '215 West Superior St. Suite 400'
          p.text 'Chicago, IL 60654'
        end
        p.stroke { p.rectangle(p.bounds.top_left, b.width, b.height) }
      end
    end
  end
end
