class BookletsController < ApplicationController

  def index
    respond_to do | format |
      format.pdf { render :layout => false }
    end
  end
end
