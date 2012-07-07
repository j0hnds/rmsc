#!/usr/bin/env ruby
#
# Dump some data out of the table.
#
# require 'mysql' # Comment out when used with rails runner

EMAIL_CORRECTIONS = {
  'sam @ kaufmans.com' => 'sam@kaufmans.com',
  'edana@skechers' => "edana@skechers.com",
  'cconrardyeaerosoles.com' => "cconrardye@aerosoles.com",
  'todd.home@consolidated shoe.com' => "todd.home@consolidated_shoe.com",
  'wendy.collins@consolidated shoe.com' => "wendy.collins@consolidated_shoe.com"
}

def clean_email(email)
  return nil if email.blank?
  # puts "### Email address: #{email}: #{EMAIL_CORRECTIONS.has_key?(email)}"
  (EMAIL_CORRECTIONS.has_key?(email)) ? EMAIL_CORRECTIONS[email] : email
end


SHOW_SQL = <<EOL
SELECT
  show_id,
  description,
  start_date,
  end_date,
  location,
  coordinator,
  location_phone,
  location_fax,
  location_reservation,
  coordinator_phone,
  coordinator_email,
  location_address,
  location_city,
  location_state,
  location_postal_code
FROM
  show
ORDER BY
  start_date DESC
EOL

EXHIBITOR_SQL = <<EOL
SELECT
  exhibitor_id,
  first_name,
  last_name,
  address_1,
  address_2,
  city,
  state,
  postal_code,
  phone,
  fax,
  cell,
  email
FROM
  exhibitor
EOL

STORE_SQL = <<EOL
SELECT
  s.store_id,
  c.name,
  s.address_1,
  s.address_2,
  s.city,
  s.state,
  s.postal_code,
  s.phone,
  s.fax
FROM
  chain c, store s
WHERE
  s.chain_id = c.chain_id
EOL

BUYER_SQL = <<EOL
SELECT
  buyer_id,
  store_id,
  first_name,
  last_name,
  email,
  cell
FROM
  buyer
EOL

EXHIBITOR_ATTENDANCE_QUERY = <<EOL
SELECT
  show_id,
  exhibitor_id,
  room_assignment
FROM
  exhibitor_attendance
EOL

BUYER_ATTENDANCE_QUERY = <<EOL
SELECT
  show_id,
  buyer_id
FROM
  buyer_attendance
EOL

ASSOCIATE_QUERY = <<EOL
SELECT
  a.associate_id,
  a.exhibitor_id,
  a.first_name,
  a.last_name,
  aa.show_id,
  aa.room_assignment
FROM
  associate a,
  associate_attendance aa
WHERE
  aa.associate_id = a.associate_id
ORDER BY
  aa.show_id DESC
EOL

ATTENDEE_LINE_QUERY = <<EOL
SELECT
  al.attendee_type,
  al.attendee_id,
  al.show_id,
  al.line,
  al.priority,
  ex.first_name,
  ex.last_name
FROM
  attendee_line al,
  exhibitor ex,
  exhibitor_attendance eatt
WHERE
  ex.exhibitor_id = al.attendee_id
  AND eatt.show_id = al.show_id
  AND eatt.exhibitor_id = ex.exhibitor_id
  AND al.attendee_type = 1
UNION
SELECT
  al.attendee_type,
  al.attendee_id,
  al.show_id,
  al.line,
  al.priority,
  a.first_name,
  a.last_name
FROM
  attendee_line al,
  associate a,
  associate_attendance aatt
WHERE
  a.associate_id = al.attendee_id
  AND aatt.show_id = al.show_id
  AND aatt.associate_id = al.attendee_id
  AND al.attendee_type = 2
ORDER BY
  show_id DESC
EOL

$show_map = {}
$exhibitor_map = {}
$store_map = {}
$buyer_map = {}

  # 0 al.attendee_type,
  # 1 al.attendee_id,
  # 2 al.show_id,
  # 3 al.line,
  # 4 al.priority,
  # 5 ex.first_name,
  # 6 ex.last_name
def create_attendee_line(row)
  # The issue here is that lines used to be assigned to an exhibitor/associate
  # for a particular show. Now, the lines are associated at the room level.
  # So, behave accordingly.
  room = nil
  # puts "### Working on attendee line with type: #{row['attendee_type']}:#{row['attendee_type'].class.name}"
  case row['attendee_type']
  when '1' # This is an exhibitor
    registration = Registration.where("show_id = ? AND exhibitor_id = ?",
                                      $show_map[row['show_id']],
                                      $exhibitor_map[row['attendee_id']]).first
    if registration.nil?
      puts "Unable to find registration for exhibitor: show(#{row['show_id']}, #{$show_map[row['show_id']]}) exhibitor(#{row['attendee_id']}, #{$exhibitor_map[row['attendee_id']]})"
      return
    end
    
    room = registration.rooms.first
    raise "No room for exhibitor line" if room.nil?

  when '2' # This is an associate
    room = Room.joins(:registration, :associates).where("show_id = ? AND associates.first_name = ? AND associates.last_name = ?",
                                                        $show_map[row['show_id']],
                                                        row['first_name'],
                                                        row['last_name']).first
                                 
  else # This is bad
    raise "Invalid attendee type: #{row['attendee_type']}"
  end

  if room.nil?
    puts "No room was found for lines! (show(#{row['show_id']}, #{$show_map[row['show_id']]}) #{row['first_name']} #{row['last_name']}"
    return
  end

  line = room.lines.where("lines.order = ? AND line = ?",
                          row['priority'],
                          row['line']).first
  if line.nil?
    line = Line.new
    line.order = row['priority']
    line.line = row['line']

    room.lines << line
  end

end

  # 0 a.associate_id,
  # 1 a.exhibitor_id,
  # 2 a.first_name,
  # 3 a.last_name,
  # 4 aa.show_id,
  # 5 aa.room_assignment

def create_associate(row)
  # Find the associated exibitor registration
  registration = Registration.where("show_id = ? AND exhibitor_id = ?", 
                                    $show_map[row['show_id']],
                                    $exhibitor_map[row['exhibitor_id']]).first
  raise "Unable to find registration for associate" if registration.nil?

  # Find the room associated with the registration
  room = registration.rooms.where("room = ?", row['room_assignment']).first
  if room.nil?
    room = Room.new
    room.room = row['room_assignment']

    # Add the room
    registration.rooms << room
  end

  # Now that we have a room, we can create the associate
  associate = Associate.new
  associate.first_name = row['first_name']
  associate.last_name = row['last_name']

  # Add the associate to the room
  room.associates << associate
end

  # 0 show_id,
  # 1 buyer_id

def create_attendance(row)
  attendance = Attendance.new
  attendance.show_id = $show_map[row['show_id']]
  attendance.buyer_id = $buyer_map[row['buyer_id']]

  attendance.save!

  attendance
end

  # 0 show_id,
  # 1 exhibitor_id,
  # 2 room_assignment

def create_registration_room(row)
  registration = Registration.new
  registration.show_id = $show_map[row['show_id']]
  registration.exhibitor_id = $exhibitor_map[row['exhibitor_id']]

  registration.save!

  room = Room.new
  room.room = row['room_assignment']

  # Add the room to the registration
  registration.rooms << room

  registration
end

  # 0 buyer_id,
  # 1 store_id,
  # 2 first_name,
  # 3 last_name,
  # 4 email,
  # 5 cell

def create_buyer(row)
  buyer = Buyer.new
  buyer.store_id = $store_map[row['store_id']]
  buyer.first_name = row['first_name']
  buyer.last_name = row['last_name']
  buyer.phone = row['cell']
  buyer.email = clean_email(row['email'])

  # puts "Buyer #{row['buyer_id']} (Store ID: #{row['store_id']}): #{buyer.inspect}"

  buyer.save!

  buyer
end

  # 0 s.store_id,
  # 1 c.name,
  # 2 s.address_1,
  # 3 s.address_2,
  # 4 s.city,
  # 5 s.state,
  # 6 s.postal_code,
  # 7 s.phone,
  # 8 s.fax

def create_store(row)
  store = Store.new
  store.name = row['name']
  store.address = row['address_1']
  store.city = row['city']
  store.state = row['state']
  store.postal_code = row['postal_code']
  store.phone = row['phone']
  store.fax = row['fax']

  # puts "Store: #{row['store_id']}: #{store.inspect}"

  store.save!

  store
end

  # 0 exhibitor_id,
  # 1 first_name,
  # 2 last_name,
  # 3 address_1,
  # 4 address_2,
  # 5 city,
  # 6 state,
  # 7 postal_code,
  # 8 phone,
  # 9 fax,
  #10 cell,
  #11 email

def create_exhibitor(row)
  exhibitor = Exhibitor.new
  exhibitor.first_name = row['first_name']
  exhibitor.last_name = row['last_name']
  exhibitor.address = row['address_1']
  exhibitor.city = row['city']
  exhibitor.state = row['state']
  exhibitor.postal_code = row['postal_code']
  exhibitor.phone = row['phone']
  exhibitor.fax = row['fax']
  exhibitor.cell = row['cell']
  exhibitor.email = clean_email(row['email'])

  exhibitor.save!

  exhibitor
end

  # 0 show_id,
  # 1 description,
  # 2 start_date,
  # 3 end_date,
  # 4 location,
  # 5 coordinator,
  # 6 location_phone,
  # 7 location_fax,
  # 8 location_reservation,
  # 9 coordinator_phone,
  #10 coordinator_email,
  #11 location_address,
  #12 location_city,
  #13 location_state,
  #14 location_postal_code

def create_show(row, venue, coordinator)
  show = Show.new(:venue => venue, :coordinator => coordinator)
  show.name = row['description']
  show.start_date = row['start_date']
  show.end_date = row['end_date']
  show.next_start_date, show.next_end_date = show.show_dates_after_date(show.start_date)

  show.save!

  show
end

  # 0 show_id,
  # 1 description,
  # 2 start_date,
  # 3 end_date,
  # 4 location,
  # 5 coordinator,
  # 6 location_phone,
  # 7 location_fax,
  # 8 location_reservation,
  # 9 coordinator_phone,
  #10 coordinator_email,
  #11 location_address,
  #12 location_city,
  #13 location_state,
  #14 location_postal_code

def create_venue(row)
  venue = Venue.new
  venue.name = row['location']
  venue.address_1 = row['location_address']
  venue.city = row['location_city']
  venue.state = row['location_state']
  venue.postal_code = row['location_postal_code']
  venue.phone = row['location_phone']
  venue.fax = row['location_fax']
  venue.reservation = row['location_reservation']

  venue.save!

  venue
end

  # 0 show_id,
  # 1 description,
  # 2 start_date,
  # 3 end_date,
  # 4 location,
  # 5 coordinator,
  # 6 location_phone,
  # 7 location_fax,
  # 8 location_reservation,
  # 9 coordinator_phone,
  #10 coordinator_email,
  #11 location_address,
  #12 location_city,
  #13 location_state,
  #14 location_postal_code

def create_coordinator(row)
  first_name, last_name = row['coordinator'].split
  coordinator = Coordinator.new
  coordinator.first_name = first_name
  coordinator.last_name = last_name
  coordinator.email = clean_email(row['coordinator_email'])
  coordinator.phone = row['coordinator_phone']

  coordinator.save!

  coordinator
end

def process_shows(my)
  index = 0
  venue = nil
  coordinator = nil

  res = my.query(SHOW_SQL)

  res.each do | row |
    if index == 0
      # Need to create the venue and coordinator on the first pass through
      # the shows.
      venue = create_venue(row)
      coordinator = create_coordinator(row)
    end

    show = create_show(row, venue, coordinator)

    $show_map[row['show_id']] = show.id

    index += 1
  end
end

def process_exhibitors(my)
  res = my.query(EXHIBITOR_SQL)

  res.each do | row |
    exhibitor = create_exhibitor(row)
    
    $exhibitor_map[row['exhibitor_id']] = exhibitor.id
  end
end

def process_stores(my)
  res = my.query(STORE_SQL)

  res.each do | row |
    store = create_store(row)

    $store_map[row['store_id']] = store.id
  end
end

def process_buyers(my)
  res = my.query(BUYER_SQL)

  res.each do | row |
    buyer = create_buyer(row)

    $buyer_map[row['buyer_id']] = buyer.id
  end
end

def process_exhibitor_attendance(my)
  res = my.query(EXHIBITOR_ATTENDANCE_QUERY)

  res.each do | row |
    create_registration_room(row)
  end
end

def process_buyer_attendance(my)
  res = my.query(BUYER_ATTENDANCE_QUERY)

  res.each do | row |
    create_attendance(row)
  end
end

def process_associates(my)
  res = my.query(ASSOCIATE_QUERY)

  res.each do | row |
    create_associate(row)
  end
end

def process_attendee_lines(my)
  res = my.query(ATTENDEE_LINE_QUERY)

  res.each do | row |
    create_attendee_line(row)
  end
end

my = PG.connect :dbname => 'RMSC', :user => 'dms', :password => 'j0rdan32'
# my = Mysql.new('localhost', 'root', 'p0rKbellie$', 'rmsc_legacy')

# Clear out the database
Associate.destroy_all
Attendance.destroy_all
Line.destroy_all
Room.destroy_all
Registration.destroy_all
Buyer.destroy_all
Store.destroy_all
Exhibitor.destroy_all
Show.destroy_all
Venue.destroy_all
Coordinator.destroy_all

ActiveRecord::Base.transaction do
  process_shows(my)

  process_exhibitors(my)

  process_stores(my)

  process_buyers(my)

  process_exhibitor_attendance(my)

  process_buyer_attendance(my)

  process_associates(my)

  process_attendee_lines(my)
end

my.close
