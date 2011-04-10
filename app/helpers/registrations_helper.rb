module RegistrationsHelper

  def exhibitor_options(exhibitors)
    exhibitors.collect { |e| ["#{e.last_name}, #{e.first_name}", e.id] }
  end

end
