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
  `show`
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

def create_attendee_line(row)
  # The issue here is that lines used to be assigned to an exhibitor/associate
  # for a particular show. Now, the lines are associated at the room level.
  # So, behave accordingly.
  room = nil
  # puts "### Working on attendee line with type: #{row[0]}:#{row[0].class.name}"
  case row[0]
  when '1' # This is an exhibitor
    registration = Registration.where("show_id = ? AND exhibitor_id = ?",
                                      $show_map[row[2]],
                                      $exhibitor_map[row[1]]).first
    if registration.nil?
      puts "Unable to find registration for exhibitor: show(#{row[2]}, #{$show_map[row[2]]}) exhibitor(#{row[1]}, #{$exhibitor_map[row[1]]})"
      return
    end
    
    room = registration.rooms.first
    raise "No room for exhibitor line" if room.nil?

  when '2' # This is an associate
    room = Room.joins(:registration, :associates).where("show_id = ? AND associates.first_name = ? AND associates.last_name = ?",
                                                        $show_map[row[2]],
                                                        row[5],
                                                        row[6]).first
                                 
  else # This is bad
    raise "Invalid attendee type: #{row[0]}"
  end

  if room.nil?
    puts "No room was found for lines! (show(#{row[2]}, #{$show_map[row[2]]}) #{row[5]} #{row[6]}"
    return
  end

  line = room.lines.where("`order` = ? AND line = ?",
                          row[4],
                          row[3]).first
  if line.nil?
    line = Line.new
    line.order = row[4]
    line.line = row[3]

    room.lines << line
  end

end

def create_associate(row)
  # Find the associated exibitor registration
  registration = Registration.where("show_id = ? AND exhibitor_id = ?", 
                                    $show_map[row[4]],
                                    $exhibitor_map[row[1]]).first
  raise "Unable to find registration for associate" if registration.nil?

  # Find the room associated with the registration
  room = registration.rooms.where("room = ?", row[5]).first
  if room.nil?
    room = Room.new
    room.room = row[5]

    # Add the room
    registration.rooms << room
  end

  # Now that we have a room, we can create the associate
  associate = Associate.new
  associate.first_name = row[2]
  associate.last_name = row[3]

  # Add the associate to the room
  room.associates << associate
end

def create_attendance(row)
  attendance = Attendance.new
  attendance.show_id = $show_map[row[0]]
  attendance.buyer_id = $buyer_map[row[1]]

  attendance.save!

  attendance
end

def create_registration_room(row)
  registration = Registration.new
  registration.show_id = $show_map[row[0]]
  registration.exhibitor_id = $exhibitor_map[row[1]]

  registration.save!

  room = Room.new
  room.room = row[2]

  # Add the room to the registration
  registration.rooms << room

  registration
end

def create_buyer(row)
  buyer = Buyer.new
  buyer.store_id = $store_map[row[1]]
  buyer.first_name = row[2]
  buyer.last_name = row[3]
  buyer.phone = row[5]
  buyer.email = clean_email(row[4])

  buyer.save!

  buyer
end

def create_store(row)
  store = Store.new
  store.name = row[1]
  store.address = row[2]
  store.city = row[4]
  store.state = row[5]
  store.postal_code = row[6]
  store.phone = row[7]
  store.fax = row[8]

  store.save!

  store
end

def create_exhibitor(row)
  exhibitor = Exhibitor.new
  exhibitor.first_name = row[1]
  exhibitor.last_name = row[2]
  exhibitor.address = row[3]
  exhibitor.city = row[5]
  exhibitor.state = row[6]
  exhibitor.postal_code = row[7]
  exhibitor.phone = row[8]
  exhibitor.fax = row[9]
  exhibitor.cell = row[10]
  exhibitor.email = clean_email(row[11])

  exhibitor.save!

  exhibitor
end

def create_show(row, venue, coordinator)
  show = Show.new(:venue => venue, :coordinator => coordinator)
  show.name = row[1]
  show.start_date = row[2]
  show.end_date = row[3]
  show.next_start_date, show.next_end_date = show.show_dates_after_date(show.start_date)

  show.save!

  show
end

def create_venue(row)
  venue = Venue.new
  venue.name = row[4]
  venue.address_1 = row[11]
  venue.city = row[12]
  venue.state = row[13]
  venue.postal_code = row[14]
  venue.phone = row[6]
  venue.fax = row[7]
  venue.reservation = row[8]

  venue.save!

  venue
end

def create_coordinator(row)
  first_name, last_name = row[5].split
  coordinator = Coordinator.new
  coordinator.first_name = first_name
  coordinator.last_name = last_name
  coordinator.email = clean_email(row[10])
  coordinator.phone = row[9]

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

    $show_map[row[0]] = show.id

    index += 1
  end
end

def process_exhibitors(my)
  res = my.query(EXHIBITOR_SQL)

  res.each do | row |
    exhibitor = create_exhibitor(row)
    
    $exhibitor_map[row[0]] = exhibitor.id
  end
end

def process_stores(my)
  res = my.query(STORE_SQL)

  res.each do | row |
    store = create_store(row)

    $store_map[row[0]] = store.id
  end
end

def process_buyers(my)
  res = my.query(BUYER_SQL)

  res.each do | row |
    buyer = create_buyer(row)

    $buyer_map[row[0]] = buyer.id
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

my = Mysql.new('localhost', 'root', 'p0rKbellie$', 'rmsc_legacy')

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
