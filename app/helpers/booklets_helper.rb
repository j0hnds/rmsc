module BookletsHelper

  def coordinator_name(coordinator)
    "#{coordinator.first_name} #{coordinator.last_name}"
  end

  def exhibitor_name(exhibitor)
    "#{exhibitor.first_name} #{exhibitor.last_name}"
  end

  def exhibitor_rooms(rooms)
    room_label = "Room"
    room_label = room_label.pluralize if rooms.count > 1

    "#{room_label}: #{rooms.collect { |r| "##{r.room}" }.join(', ')}"
  end

  def exhibitor_address(exhibitor)
    "#{exhibitor.address}\n#{exhibitor.city}, #{exhibitor.state}  #{exhibitor.postal_code}"
  end

  def exhibitor_lines(exhibitor)
    ""
  end

  def venue_address(venue)
    "#{venue.address_1}\n#{venue.city}, #{venue.state}  #{venue.postal_code}"
  end
end
