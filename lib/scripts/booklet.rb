require 'prawn'
require 'prawn/layout'

class Booklet

  def initialize
    @document = Prawn::Document.new(:page_layout => :portrait,
                               :page_size => 'LETTER')
    puts "### Document is initialized: #{@document}"
  end
  # The default margin defaults 0.5in

  def title_page
    # put an image on the page
    @document.image 'public/images/mountains.jpeg', :position => :center
    @document.text 'Rocky Mountain', :size => 30, :style => :bold, :align => :center
    @document.move_down 18
    @document.text 'Shoe Show', :size => 30, :style => :bold, :align => :center
    @document.move_down 18
    @document.text 'Denver Market', :size => 20, :style => :bold, :align => :center
    @document.move_down 36
    @document.text 'Show Start', :size => 18, :style => :bold, :align => :center
    @document.text 'Show Location', :size => 18, :style => :bold, :align => :center
    @document.text 'Show Address', :size => 18, :style => :bold, :align => :center
    @document.move_down 36

    @document.table [['Saturday', '9am to 5pm'],
                     ['Sunday', '9am to 5pm']], :position => :center, :border_width => 0

    @document.move_down 18

    @document.text 'Friday & Monday - by Appointment only', :size => 15, :align => :center

  end

  def welcome_page
    @document.start_new_page

    @document.text 'Welcome to the Market', :size => 20, :style => :bold, :align => :center
    @document.move_down 20

    @document.text "Members of the Rocky Mountain Shoe Club welcome you to the {0}, {1} Denver Shoe Market.", :size => 16

    @document.move_down 20

    @document.text "We have over {0} Reps, marketing over {1} lines including shoes, socks, slippers and handbags.", :size => 16
    @document.move_down 40

    @document.text 'Lunch', :size => 16, :style => :bold, :align => :center
    @document.move_down 20

    @document.text "Lunch will be served Saturday and Sunday from 12:00pm to 1:30pm in the Aspen room and lounge area.", :size => 16
    @document.move_down 20

    @document.text "Retailers and exhibitors - We will be having a social hour on Saturday night in the Aspen room starting at 5:00pm.", :size => 16
    @document.move_down 20

    @document.text "Snacks and soft drinks will be provided.", :size => 16
    @document.move_down 20

    @document.text "Alcoholic beverages will be provided by the exhibitors.", :size => 16
    @document.move_down 36

    @document.text "NEXT SHOE MARKET", :size => 26, :style => :bold, :align => :center
    @document.text "Next Show Date", :size => 26, :style => :bold, :align => :center
    @document.move_down 30

    @document.text "Show Coordinator: {0}", :size =>16, :align => :center
    @document.text "Phone: {0}", :size => 16, :align => :center
    @document.text "Coordinator Email", :size => 16, :align => :center
    
  end

  def exhibitor_name_cards
    names = []
    20.times do | idx |
      names << "FirstName LastName"
    end

    lines = "Line One, Line Two, Line Three, Line Four, Line Five"

    names.each_slice(6) do | page_worth |
      @document.start_new_page

      @document.define_grid(:columns => 2, 
                            :rows => 3, 
                            :column_gutter => 12, 
                            :row_gutter => 10)
      page_worth.each_with_index do | label, idx |
        col = idx % 2
        row = (idx < 2) ? 0 : (idx < 4) ? 1 : 2
        b = @document.grid(row, col)
        @document.bounding_box b.top_left, :width => b.width, :height => b.height do
          @document.text "label\nRoom #101", :size => 16
          @document.text "{0}\n{1}, {2} {3}\n", :size => 16
          @document.text "Phone: {3}\n", :size => 16
          @document.text "Fax: {3}\n", :size => 16
          @document.text "Cell: {3}\n", :size => 16
          @document.text "Email: {3}\n", :size => 16
          @document.text "Lines:", :size => 16, :style => :bold
          @document.text lines, :size => 16, :style => :bold
        end
      end
    end
  end

  def line_room_exhibitors
    @document.start_new_page

    header = %w{ LINES ROOM EXHIBITOR }

    data = [ 'Line One', '1001', 'John Doe' ]
    
    @document.table([data] * 50, 
                    :headers => header, 
                    :align_headers => :left,
                    :column_widths => { 
                      0 => @document.bounds.width * 0.5,
                      1 => @document.bounds.width * 0.15,
                      2 => @document.bounds.width * 0.35 },
                    :align => {
                      0 => :left,
                      1 => :left,
                      2 => :left },
                    :row_colors => [ 'cccccc', 'aaaaaa' ],
                    :font_size => 15,
                    :border_style => :underline_header,
                    :width => @document.bounds.width) do
      row(0).style(:style => :bold)
    end
  end

  def thank_you
    @document.start_new_page
    
    page_number = @document.page_number
    if page_number % 4 > 0
      puts "### Page number at thank you: #{page_number}"
      mod_number = page_number % 4
      puts "### Mod of page number: #{mod_number}"
      num_notes_pages = (4 - mod_number)
      num_notes_pages.times do 
        @document.text "NOTES", :size => 20, :style => :bold, :align => :center
        @document.start_new_page
      end
    end

    # Now we can start the thank you
    @document.text "THANK YOU", :size => 20, :style => :bold, :align => :center
    @document.move_down 20

    @document.text 'FOR COMING TO THE SHOW', :size => 20, :style => :bold, :align => :center
    @document.move_down 100

    @document.text 'NEXT MARKET', :size => 20, :align => :center
    @document.move_down 20

    @document.text "Next Show Dates", :size => 20, :align => :center
    @document.move_down 100

    @document.text "Show Location", :size => 20, :align => :center
    @document.text "Show Location Address", :size => 20, :align => :center

    @document.text "Phone {0}", :size => 20, :align => :center
    @document.text "Fax {0}", :size => 20, :align => :center
    
  end

  def render(pdf_file)
    @document.render_file(pdf_file)
  end

end


booklet = Booklet.new
booklet.title_page
booklet.welcome_page
booklet.exhibitor_name_cards
booklet.line_room_exhibitors
booklet.thank_you

# Render the document
booklet.render('booklet.pdf')
