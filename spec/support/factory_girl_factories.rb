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

Factory.define :exhibitor do |f|
  f.first_name 'Joe'
  f.last_name 'Exhibitor'
  f.address '123 Main St'
  f.city 'San Andreas'
  f.state 'GA'
  f.postal_code '01101-2345'
  f.phone '202-222-2222'
  f.fax '202-222-2222'
  f.cell '202-222-2222'
  f.email 'joe.exhibitor@mail.com'
end

Factory.define :store do |f|
  f.name 'Shoe Store'
  f.address '123 Main'
  f.city 'Aberdeen'
  f.state 'CT'
  f.postal_code '90111'
  f.phone '303 333 3333'
  f.fax '404 444 4444'
  f.email 'shoe_store@mail.com'
end

Factory.define :buyer do |f|
  f.first_name 'Joe'
  f.last_name 'Buyer'
  f.phone '303 333 3333'
  f.email 'joe.buyer@mail.com'
end