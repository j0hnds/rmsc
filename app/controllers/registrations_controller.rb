class RegistrationsController < ApplicationController
  include BookletsHelper

  layout 'primary', :only => [ :index ]

  def index
    respond_to do | format |
      format.pdf {
        @show_lines = Line.for_show(@current_show).collect do | line |
          [ line.line, exhibitor_name(line.room.registration.exhibitor), select_exhibitor_phone(line.room.registration.exhibitor) ]
        end
      }
      format.html {
        @exhibitor_registrations = @current_show.registrations.joins(:exhibitor).order("last_name ASC, first_name ASC")
      }
    end
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

  def unregistered_exhibitors
    @unregistered_exhibitors = Exhibitor.not_in_show(@current_show).ordered_by_name
  end

  def register_exhibitors
    # We will get the list of selected exhibitors to register
    exhibitors = Exhibitor.find(params[:exhibitors])

    exhibitors.each do | e |
      @current_show.register_exhibitor(e)
    end

    @exhibitor_registrations = @current_show.registrations.joins(:exhibitor).order("last_name ASC, first_name ASC")
    render :action => :success and return if request.xhr?
    render :index
  end

  def destroy
    Registration.destroy(params[:id])
    redirect_to registrations_path
  end

  def add_room
    registration = Registration.find(params[:id])

    registration.rooms << Room.new

    redirect_to registrations_path
  end

  def delete_room
    registration = Registration.find(params[:id])
    Room.destroy(params[:room_id])

    redirect_to registrations_path
  end

  private

  def select_exhibitor_phone(exhibitor)
    phone = exhibitor.phone
    phone ||= exhibitor.cell
    phone
  end
end
