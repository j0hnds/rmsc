class ApplicationController < ActionController::Base
  protect_from_forgery

  def get_search_term
    if params[:search]
      session[:search] = params[:search]
    else
      session[:search]
    end
  end
end
