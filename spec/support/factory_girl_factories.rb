FactoryGirl.define do

  sequence :name do |n|
    "Name#{n}"
  end

  sequence :line do |n|
    "Line #{n}"
  end

  sequence :room do |n|
    (n + 1).to_s
  end

  factory :coordinator do
    first_name { generate(:name) }
    last_name { generate(:name) }
    phone '303 333 3333'
    email 'joe.smith@email.com'
  end

  factory :venue do
    name { generate(:name) }
    address_1 '101 Main Street'
    city 'Santa Monica'
    state 'SD'
    postal_code '11100-2222'
    phone '101 111 1111'
    fax '202 222 2222'
  end

  # For create, must specify a venue and a coordinator
  factory :show do
    name { generate(:name) }
    start_date Date.today
    end_date Date.today + 1.day
    next_start_date Date.today
    next_end_date Date.today + 1.day
  end

  factory :exhibitor do
    first_name { generate(:name) }
    last_name { generate(:name) }
    address '123 Main St'
    city 'San Andreas'
    state 'GA'
    postal_code '01101-2345'
    phone '202-222-2222'
    fax '202-222-2222'
    cell '202-222-2222'
    email 'joe.exhibitor@mail.com'
  end

  factory :store do
    name { generate(:name) }
    address '123 Main'
    city 'Aberdeen'
    state 'CT'
    postal_code '90111'
    phone '303 333 3333'
    fax '404 444 4444'
    email 'shoe_store@mail.com'
  end

  factory :buyer do
    first_name { generate(:name) }
    last_name { generate(:name) }
    phone '303 333 3333'
    email 'joe.buyer@mail.com'
  end

  factory :registration do

  end

  factory :room do
    room { generate(:room) }
  end

  factory :associate do
    first_name { generate(:name) }
    last_name { generate(:name) }
  end

  factory :line do
    order 1
    line { generate(:line) }
  end

end
