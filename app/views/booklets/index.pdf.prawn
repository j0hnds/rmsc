require 'prawn/layout'
# Do the title page

# put an image on the page
pdf.image 'public/images/mountains.jpeg', :position => :center
pdf.text 'Rocky Mountain', :size => 30, :style => :bold, :align => :center
pdf.move_down 18
pdf.text 'Shoe Show', :size => 30, :style => :bold, :align => :center
pdf.move_down 18
pdf.text 'Denver Market', :size => 20, :style => :bold, :align => :center
pdf.move_down 36
pdf.text 'Show Start', :size => 18, :style => :bold, :align => :center
pdf.text 'Show Location', :size => 18, :style => :bold, :align => :center
pdf.text 'Show Address', :size => 18, :style => :bold, :align => :center
pdf.move_down 36

pdf.table [['Saturday', '9am to 5pm'],
           ['Sunday', '9am to 5pm']], :position => :center, :border_width => 0

pdf.move_down 18

pdf.text 'Friday & Monday - by Appointment only', :size => 15, :align => :center

# The welcome page
pdf.start_new_page

pdf.text 'Welcome to the Market', :size => 20, :style => :bold, :align => :center
pdf.move_down 20

pdf.text "Members of the Rocky Mountain Shoe Club welcome you to the {0}, {1} Denver Shoe Market.", :size => 16

pdf.move_down 20

pdf.text "We have over {0} Reps, marketing over {1} lines including shoes, socks, slippers and handbags.", :size => 16
pdf.move_down 40

pdf.text 'Lunch', :size => 16, :style => :bold, :align => :center
pdf.move_down 20

pdf.text "Lunch will be served Saturday and Sunday from 12:00pm to 1:30pm in the Aspen room and lounge area.", :size => 16
pdf.move_down 20

pdf.text "Retailers and exhibitors - We will be having a social hour on Saturday night in the Aspen room starting at 5:00pm.", :size => 16
pdf.move_down 20

pdf.text "Snacks and soft drinks will be provided.", :size => 16
pdf.move_down 20

pdf.text "Alcoholic beverages will be provided by the exhibitors.", :size => 16
pdf.move_down 36

pdf.text "NEXT SHOE MARKET", :size => 26, :style => :bold, :align => :center
pdf.text "Next Show Date", :size => 26, :style => :bold, :align => :center
pdf.move_down 30

pdf.text "Show Coordinator: {0}", :size =>16, :align => :center
pdf.text "Phone: {0}", :size => 16, :align => :center
pdf.text "Coordinator Email", :size => 16, :align => :center
    
# Do the exhibitor name cards
names = []
20.times do | idx |
  names << "FirstName LastName"
end

lines = "Line One, Line Two, Line Three, Line Four, Line Five"

names.each_slice(6) do | page_worth |
  pdf.start_new_page

  pdf.define_grid(:columns => 2, 
                        :rows => 3, 
                        :column_gutter => 12, 
                        :row_gutter => 10)
  page_worth.each_with_index do | label, idx |
    col = idx % 2
    row = (idx < 2) ? 0 : (idx < 4) ? 1 : 2
    b = pdf.grid(row, col)
    pdf.bounding_box b.top_left, :width => b.width, :height => b.height do
      pdf.text "label\nRoom #101", :size => 16
      pdf.text "{0}\n{1}, {2} {3}\n", :size => 16
      pdf.text "Phone: {3}\n", :size => 16
      pdf.text "Fax: {3}\n", :size => 16
      pdf.text "Cell: {3}\n", :size => 16
      pdf.text "Email: {3}\n", :size => 16
      pdf.text "Lines:", :size => 16, :style => :bold
      pdf.text lines, :size => 16, :style => :bold
    end
  end
end

# Now, do the line room exhibitors table
pdf.start_new_page

header = %w{ LINES ROOM EXHIBITOR }

data = [ 'Line One', '1001', 'John Doe' ]
    
pdf.table([data] * 50, 
                :headers => header, 
                :align_headers => :left,
                :column_widths => { 
                  0 => pdf.bounds.width * 0.5,
                  1 => pdf.bounds.width * 0.15,
                  2 => pdf.bounds.width * 0.35 },
                :align => {
                  0 => :left,
                  1 => :left,
                  2 => :left },
                :row_colors => [ 'cccccc', 'aaaaaa' ],
                :font_size => 15,
                :border_style => :underline_header,
                :width => pdf.bounds.width) do
  row(0).style(:style => :bold)
end

# Now, do the thank you page
pdf.start_new_page
    
page_number = pdf.page_number
if page_number % 4 > 0
  puts "### Page number at thank you: #{page_number}"
  mod_number = page_number % 4
  puts "### Mod of page number: #{mod_number}"
  num_notes_pages = (4 - mod_number)
  num_notes_pages.times do 
    pdf.text "NOTES", :size => 20, :style => :bold, :align => :center
    pdf.start_new_page
  end
end

# Now we can start the thank you
pdf.text "THANK YOU", :size => 20, :style => :bold, :align => :center
pdf.move_down 20
pdf.text 'FOR COMING TO THE SHOW', :size => 20, :style => :bold, :align => :center
pdf.move_down 100

pdf.text 'NEXT MARKET', :size => 20, :align => :center
pdf.move_down 20

pdf.text "Next Show Dates", :size => 20, :align => :center
pdf.move_down 100

pdf.text "Show Location", :size => 20, :align => :center
pdf.text "Show Location Address", :size => 20, :align => :center

pdf.text "Phone {0}", :size => 20, :align => :center
pdf.text "Fax {0}", :size => 20, :align => :center
