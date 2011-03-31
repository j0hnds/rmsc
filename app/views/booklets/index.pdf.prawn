require 'prawn/layout'
# Do the title page

# put an image on the page
pdf.image('public/images/mountains.jpeg', 
          :position => :center)
pdf.text('Rocky Mountain', 
         :size => 30, 
         :style => :bold, 
         :align => :center)
pdf.move_down 18
pdf.text('Shoe Show', 
         :size => 30, 
         :style => :bold, 
         :align => :center)
pdf.move_down 18
pdf.text('Denver Market', 
         :size => 20, 
         :style => :bold, 
         :align => :center)
pdf.move_down 36
pdf.text(@current_show.start_date.strftime('%B %d, %Y'), 
         :size => 18, 
         :style => :bold, 
         :align => :center)
pdf.text(@current_show.venue.name, 
         :size => 18, 
         :style => :bold, 
         :align => :center)
pdf.text(@current_show.venue.address_1, 
         :size => 18, 
         :style => :bold, 
         :align => :center)
pdf.move_down 36

pdf.table([['Saturday', '9am to 5pm'],
           ['Sunday', '9am to 5pm']], 
          :position => :center, 
          :border_width => 0)

pdf.move_down 18

pdf.text('Friday & Monday - by Appointment only', 
         :size => 15, 
         :align => :center)

# The welcome page
pdf.start_new_page

pdf.text('Welcome to the Market', 
         :size => 20, 
         :style => :bold, 
         :align => :center)
pdf.move_down 20

pdf.text("Members of the Rocky Mountain Shoe Club welcome you to the #{@current_show.start_date.strftime('%B, %Y')} Denver Shoe Market.", 
         :size => 16)

pdf.move_down 20

pdf.text("We have over #{@show_exhibitor_count} Reps, marketing over #{(@show_line_count/10)*10} lines including shoes, socks, slippers and handbags.", 
         :size => 16)
pdf.move_down 40

pdf.text('Lunch', 
         :size => 16, 
         :style => :bold, 
         :align => :center)
pdf.move_down 20

pdf.text("Lunch will be served Saturday and Sunday from 12:00pm to 1:30pm in the Aspen room and lounge area.", 
         :size => 16)
pdf.move_down 20

pdf.text("Retailers and exhibitors - We will be having a social hour on Saturday night in the Aspen room starting at 5:00pm.", 
         :size => 16)
pdf.move_down 20

pdf.text("Snacks and soft drinks will be provided.", 
         :size => 16)
pdf.move_down 20

pdf.text("Alcoholic beverages will be provided by the exhibitors.", 
         :size => 16)
pdf.move_down 36

pdf.text("NEXT SHOE MARKET", 
         :size => 26, 
         :style => :bold, 
         :align => :center)
pdf.text("#{@current_show.next_start_date.strftime("%B %d")} & #{@current_show.next_end_date.strftime("%d, %Y")}", 
         :size => 26, 
         :style => :bold, 
         :align => :center)
pdf.move_down 30

pdf.text("Show Coordinator: #{coordinator_name(@current_show.coordinator)}", 
         :size =>16, 
         :align => :center)
pdf.text("Phone: #{@current_show.coordinator.phone}", 
         :size => 16, 
         :align => :center)
pdf.text("#{@current_show.coordinator.email}", 
         :size => 16, 
         :align => :center)
    
@exhibitors.each_slice(6) do | page_worth |
  pdf.start_new_page

  pdf.define_grid(:columns => 2, 
                  :rows => 3, 
                  :column_gutter => 12, 
                  :row_gutter => 10)

  page_worth.each_with_index do | exhibitor, idx |
    col = idx % 2
    row = (idx < 2) ? 0 : (idx < 4) ? 1 : 2
    b = pdf.grid(row, col)
    pdf.bounding_box b.top_left, :width => b.width, :height => b.height do
      pdf.text("#{exhibitor_name(exhibitor)}\n#{exhibitor_rooms(@exhibitor_rooms[exhibitor.id])}", 
               :size => 15,
               :style => :bold)
      pdf.text("#{exhibitor_address(exhibitor)}\n", 
               :size => 15)
      pdf.text("Phone: #{exhibitor.phone}\n", 
               :size => 15) unless exhibitor.phone.blank?
      pdf.text("Fax: #{exhibitor.fax}\n", 
               :size => 15) unless exhibitor.fax.blank?
      pdf.text("Cell: #{exhibitor.cell}\n", 
               :size => 15) unless exhibitor.cell.blank?
      pdf.text("Email: #{exhibitor.email}\n", 
               :size => 15) unless exhibitor.email.blank?
      pdf.text("Lines:", 
               :size => 15,
               :style => :bold)
      pdf.text(@exhibitor_lines[exhibitor.id].join(', '), 
               :size => 14, 
               :style => :bold)
    end
  end
end

# Now, do the line room exhibitors table
pdf.start_new_page

header = %w{ LINES ROOM EXHIBITOR }

# data = [ 'Line One', '1001', 'John Doe' ]
    
pdf.table(@show_lines, 
          :headers => header, 
          :header_color => 'cccccc',
          :align_headers => :left,
          :column_widths => { 
            0 => pdf.bounds.width * 0.5,
            1 => pdf.bounds.width * 0.15,
            2 => pdf.bounds.width * 0.35 },
          :align => {
            0 => :left,
            1 => :left,
            2 => :left },
          :row_colors => [ 'ffffff', 'eeeeee' ],
          :font_size => 15,
          :border_style => :underline_header,
          :width => pdf.bounds.width) do
  # row(0).style(:font_style => :bold)
end

# Now, do the thank you page
pdf.start_new_page
    
# Calculate and process the notes pages for filler.
page_number = pdf.page_number
if page_number % 4 > 0
  # puts "### Page number at thank you: #{page_number}"
  mod_number = page_number % 4
  # puts "### Mod of page number: #{mod_number}"
  num_notes_pages = (4 - mod_number)
  num_notes_pages.times do 
    pdf.text("NOTES", 
             :size => 20, 
             :style => :bold, 
             :align => :center)
    pdf.start_new_page
  end
end

# Now we can start the thank you
pdf.text("THANK YOU", 
         :size => 20, 
         :style => :bold, 
         :align => :center)
pdf.move_down 20
pdf.text('FOR COMING TO THE SHOW', 
         :size => 20, 
         :style => :bold, 
         :align => :center)
pdf.move_down 100

pdf.text('NEXT MARKET', 
         :size => 20, 
         :align => :center)
pdf.move_down 20

pdf.text("#{@current_show.next_start_date.strftime("%B %d")} & #{@current_show.next_end_date.strftime("%d, %Y")}", 
         :size => 20,
         :align => :center)
pdf.move_down 100

pdf.text(@current_show.venue.name, 
         :size => 20, 
         :align => :center)
pdf.text(venue_address(@current_show.venue), 
         :size => 20, 
         :align => :center)

pdf.text("Phone: #{@current_show.venue.phone}", 
         :size => 20, 
         :align => :center)
pdf.text("Fax #{@current_show.venue.fax}", 
         :size => 20, 
         :align => :center)
