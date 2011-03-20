module AttendancesHelper
  def buyer_options(buyers)
    buyers.collect { |b| ["#{b.last_name}, #{b.first_name}", b.id] }
  end
end
