module ShowContext

  def identify_current_show
    @show_list = Show.ordered_by_most_recent

    # Check the session
    @current_show = Show.find(session[:current_show]) if session[:current_show]
    @current_show ||= @show_list.first
  end

end