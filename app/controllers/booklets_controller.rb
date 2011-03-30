class BookletsController < ApplicationController
  include BookletsHelper

  def index
    @show_exhibitor_count = @current_show.exhibitors.count
    @show_line_count = Line.joins(:room => :registration).where('show_id = ?', @current_show.id).count

    @exhibitors = @current_show.exhibitors
    @exhibitor_lines = {}
    @exhibitors.each do | e | 
      @exhibitor_lines[e.id] = Line.for_exhibitor(@current_show, e).collect(&:line) 
    end

    @show_lines = Line.for_show(@current_show).collect do | line |
      [ line.line, line.room.room, exhibitor_name(line.room.registration.exhibitor) ]
    end

    respond_to do | format |
      format.pdf { render :layout => false }
    end
  end
end
