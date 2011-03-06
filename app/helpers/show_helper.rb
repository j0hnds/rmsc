module ShowHelper

  DATE_FORMAT = "%Y-%m-%d"

  def coordinator_options(coordinators)
    coordinators.collect { | c | [ format_coordinator_name(c), c.id ]}
  end

  def venue_options(venues)
    venues.collect { | v | [ format_venue(v) , v.id ]}
  end

  def format_date_range(start_date, end_date)
    "#{start_date.strftime(DATE_FORMAT)} -- #{end_date.strftime(DATE_FORMAT)}"
  end
end