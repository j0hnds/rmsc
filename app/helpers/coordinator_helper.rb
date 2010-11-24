module CoordinatorHelper
  def format_coordinator_name(coordinator)
    "#{coordinator.last_name}, #{coordinator.first_name}"
  end
end
