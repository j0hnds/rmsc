class AttendancesController < ApplicationController
  include BuyersHelper

  layout 'primary', :only => [ :index ]

  prawnto :prawn => { :page_layout => :landscape }

  def index
    respond_to do | format |
      format.pdf {
        attendances = Attendance.for_show(@current_show).joins(:buyer => :store).order("name ASC, last_name ASC, first_name ASC")
        @buyer_rows = attendances.collect do | attendance |
          [
              format_buyer_name(attendance.buyer),
              safe_string(attendance.buyer.store.name),
              safe_string(attendance.buyer.store.address),
              safe_string(attendance.buyer.store.city),
              safe_string(attendance.buyer.store.state),
              safe_string(attendance.buyer.store.postal_code),
              safe_string(attendance.buyer.store.phone)
          ]
        end
      }
      format.html {
        @buyer_attendances = Attendance.for_show(@current_show).joins(:buyer).order("last_name ASC, first_name ASC")
      }
    end
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

  private

  def safe_string(value)
    (value) ? value.to_s : ''
  end


end
