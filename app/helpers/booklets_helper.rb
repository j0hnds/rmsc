module BookletsHelper

  def coordinator_name(coordinator)
    "#{coordinator.first_name} #{coordinator.last_name}"
  end

  def exhibitor_name(exhibitor)
    "#{exhibitor.first_name} #{exhibitor.last_name}"
  end

  def exhibitor_rooms(exhibitor)
    room_label = "Room"
    room_label.pluralize if exhibitor.rooms.count > 1

    "#{room_label}: #{exhibitor.rooms.collect(&:room).join(', ')}"
  end

  def exhibitor_address(exhibitor)
    "#{exhibitor.address}\n#{exhibitor.city}, #{exhibitor.state} #{exhibitor.postal_code}"
  end

  def exhibitor_lines(exhibitor)
    ""
  end

  def venue_address(venue)
    <<-ADDRESS
#{venue.address_1}
#{venue.city}, #{venue.state}  #{venue.postal_code}
ADDRESS
  end
end
