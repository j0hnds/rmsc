module VenueHelper
  def format_venue_address(venue)
    address = venue.address_1
    address << "<br>#{venue.address_2}" unless venue.address_2.blank?
    address << "<br>#{venue.city}, #{venue.state} #{venue.postal_code}"
  end

  def format_venue(venue)
    "#{venue.name} - #{venue.address_1}, #{venue.city}"
  end
end
