class RegistrationsController < ApplicationController

  layout 'primary', :only => [ :index ]

  def index
    @exhibitor_registrations = @current_show.registrations.joins(:exhibitor).order("last_name ASC, first_name ASC")
  end

  def room
    room_id = params[:element_id]
    new_room = params[:update_value]
    room = Room.find(room_id)
    room.update_attribute(:room, new_room)
    render :text => new_room
  end

  def lines
    room_id = params[:element_id]
    new_lines = params[:update_value]
    room = Room.find(room_id)

    # The lines will be a comma-separated list of strings; each string is a line
    # and the order in which they come in will be the order in the database.
    line_ary = new_lines.split(/,/).collect { | l | l.strip }
    room.lines.delete_all
    line_ary.each_with_index do | l, idx |
      room.lines << Line.new(:line => l, :order => idx)
    end

    render :text => new_lines
  end

  def associates
    room_id = params[:element_id]
    new_associates = params[:update_value]
    room = Room.find(room_id)

    # The lines will be a comma-separated list of strings; each string is a line
    # and the order in which they come in will be the order in the database.
    associates_ary = new_associates.split(/,/).collect { | l | l.strip }
    room.associates.delete_all
    associates_ary.each_with_index do | a, idx |
      first_name, last_name = a.split(' ')
      room.associates << Associate.new(:first_name => first_name, :last_name => last_name)
    end

    render :text => new_associates
  end
end
