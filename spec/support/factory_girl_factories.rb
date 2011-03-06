Factory.define :coordinator do |f|
  f.first_name 'Joe'
  f.last_name 'Smith'
  f.phone '303 333 3333'
  f.email 'joe.smith@email.com'
end

Factory.define :venue do |f|
  f.name 'Venue'
  f.address_1 '101 Main Street'
  f.city 'Santa Monica'
  f.state 'SD'
  f.postal_code '11100-2222'
end

# For create, must specify a venue and a coordinator
Factory.define :show do |f|
  f.name 'Show 1'
  f.start_date Date.today
  f.end_date Date.today + 1.day
  f.next_start_date Date.today
  f.next_end_date Date.today + 1.day
end