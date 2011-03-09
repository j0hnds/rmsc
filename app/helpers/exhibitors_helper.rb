module ExhibitorsHelper

  def format_exhibitor_name(exhibitor)
    "#{exhibitor.last_name}, #{exhibitor.first_name}"
  end

  def format_exhibitor_address(exhibitor)
    address = exhibitor.address
    address << "<br>#{exhibitor.city}, #{exhibitor.state} #{exhibitor.postal_code}"
  end

end
