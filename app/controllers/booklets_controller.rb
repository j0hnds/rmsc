class BookletsController < ApplicationController
  include BookletsHelper

  def index
    @show_exhibitor_count = @current_show.exhibitors.count
    @show_line_count = Line.for_show(@current_show).collect(&:line).uniq.count

    @exhibitors = @current_show.exhibitors.ordered_by_name
    @exhibitor_lines = {}
    @exhibitor_rooms = {}
    @exhibitors.each do | e | 
      @exhibitor_lines[e.id] = Line.for_exhibitor(@current_show, e).collect(&:line) 
      @exhibitor_rooms[e.id] = Room.for_exhibitor(@current_show, e)
    end

    @show_lines = Line.for_show(@current_show).collect do | line |
      [ line.line, line.room.room, exhibitor_name(line.room.registration.exhibitor) ]
    end

    respond_to do | format |
      format.pdf { render :layout => false }
    end
  end
end
