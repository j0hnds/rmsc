module RegistrationsHelper

  def exhibitor_options(exhibitors)
    exhibitors.collect { |e| ["#{e.last_name}, #{e.first_name}", e.id] }
  end
#  def format_lines(lines)
#    lines.collect { |l| l.line }.join(", ")
#  end
#
#  def format_associates(associates)
#    associates.collect { | a | "#{a.first_name} #{a.last_name}" }.join(", ")
#  end
end
