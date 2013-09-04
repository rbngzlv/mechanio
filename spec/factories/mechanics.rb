FactoryGirl.define do
  factory :mechanic do
    first_name      'John'
    last_name       'Doe'
    email           'email@host.com'
    password        'password'
    dob             { 25.years.ago }
    description     'I am a great mechanic'
    street_address  'Seashell avenue'
    suburb          'Not sure'
    state           { State.find_or_create_by(name: 'Queensland') }
    postcode        'AXC1212'
    driver_license  'CBN123447765'
    license_state   { State.find_or_create_by(name: 'Queensland') }
    license_expiry  { Time.now + 1.year }
  end
end
