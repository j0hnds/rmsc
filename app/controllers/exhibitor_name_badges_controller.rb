class ExhibitorNameBadgesController < ApplicationController

  layout 'primary', :only => [ :index ]

  AVERY_XXXX_MARGIN = 13.5 # 16 # 0.21975in * 72ppi = 15.82
  TOP_BOTTOM_MARGIN = 36

  prawnto :prawn => {
      :page_layout => :portrait,
      :top_margin => TOP_BOTTOM_MARGIN,
      :bottom_margin => TOP_BOTTOM_MARGIN,
      :left_margin => AVERY_5160_MARGIN,
      :right_margin => AVERY_5160_MARGIN
  }

  def index
    @exhibitors = @current_show.exhibitors.ordered_by_name
  end

  def print
    
    @registrations = Registrations.joins(:exhibitor).where('show_id = ?, exhibitor_id in (?)', @current_show_id, params[:exhibitors_needing_name_badges]).order('last_name ASC, first_name ASC')
    respond_to do | format |
      format.pdf {
        render :layout => false
      }
    end
  end

end
