Factory.sequence :name do |n|
  "Name#{n}"
end

Factory.sequence :line do |n|
  "Line #{n}"
end

Factory.sequence :room do |n|
  (n + 1).to_s
end

Factory.define :coordinator do |f|
  f.first_name Factory.next :name
  f.last_name Factory.next :name
  f.phone '303 333 3333'
  f.email 'joe.smith@email.com'
end

Factory.define :venue do |f|
  f.name Factory.next :name
  f.address_1 '101 Main Street'
  f.city 'Santa Monica'
  f.state 'SD'
  f.postal_code '11100-2222'
  f.phone '101 111 1111'
  f.fax '202 222 2222'
end

# For create, must specify a venue and a coordinator
Factory.define :show do |f|
  f.name Factory.next :name
  f.start_date Date.today
  f.end_date Date.today + 1.day
  f.next_start_date Date.today
  f.next_end_date Date.today + 1.day
end

Factory.define :exhibitor do |f|
  f.first_name Factory.next :name
  f.last_name Factory.next :name
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
  f.name Factory.next :name
  f.address '123 Main'
  f.city 'Aberdeen'
  f.state 'CT'
  f.postal_code '90111'
  f.phone '303 333 3333'
  f.fax '404 444 4444'
  f.email 'shoe_store@mail.com'
end

Factory.define :buyer do |f|
  f.first_name Factory.next :name
  f.last_name Factory.next :name
  f.phone '303 333 3333'
  f.email 'joe.buyer@mail.com'
end

Factory.define :registration do |f|

end

Factory.define :room do |f|
  f.room Factory.next :room
end

Factory.define :associate do |f|
  f.first_name Factory.next :name
  f.last_name Factory.next :name
end

Factory.define :line do |f|
  f.order 1
  f.line Factory.next :line
end