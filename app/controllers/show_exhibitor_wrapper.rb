class ShowExhibitorWrapper

  def initialize(shows)
    @shows = shows
  end

  def number_of_exhibitors
    1
  end

  def name
    "Exhibitors"
  end

  def data_series
    [ @shows.map ]
  end

end