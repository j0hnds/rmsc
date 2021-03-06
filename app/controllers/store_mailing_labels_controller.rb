class StoreMailingLabelsController < ApplicationController

  layout 'primary', :only => [ :index ]

  AVERY_5160_MARGIN = 13.5 # 16 # 0.21975in * 72ppi = 15.82
  TOP_BOTTOM_MARGIN = 36

  prawnto :prawn => {
      :page_layout => :portrait,
      :top_margin => TOP_BOTTOM_MARGIN,
      :bottom_margin => TOP_BOTTOM_MARGIN,
      :left_margin => AVERY_5160_MARGIN,
      :right_margin => AVERY_5160_MARGIN
  }

  def index
    @stores = Store.ordered_by_name
  end

  def print
    @stores = Store.find(params[:stores_to_mail])
    puts "### The number of stores we will print: #{@stores.size}"
    respond_to do | format |
      format.pdf {
        render :layout => false
      }
    end
  end
end
