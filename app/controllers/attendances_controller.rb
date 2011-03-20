class AttendancesController < ApplicationController

  layout 'primary', :only => [ :index ]

  def index
    @buyer_attendances = Attendance.for_show(@current_show).joins(:buyer).order("last_name ASC, first_name ASC")
  end

  def non_attending_buyers
    @non_attending_buyers = Buyer.not_in_show(@current_show).ordered_by_name
  end

  def register_buyers
    # We will get the list of selected exhibitors to register
    buyers = Buyer.find(params[:buyers])

    buyers.each do | b |
      @current_show.buyers << b
    end

    @buyer_attendances = Attendance.for_show(@current_show).joins(:buyer).order("last_name ASC, first_name ASC")
    render :action => :success and return if request.xhr?
    render :index
  end

  def destroy
    Attendance.destroy(params[:id])
    redirect_to attendances_path
  end


end
