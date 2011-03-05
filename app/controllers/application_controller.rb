class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def get_search_term
    key = search_key

    if params[:search]
      session[key] = params[:search]
    else
      session[key]
    end

    @search = session[key]
  end

  def search_key
    "#{request[:controller]}_search"
  end
end
