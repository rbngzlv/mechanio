FactoryGirl.define do
  factory :mechanic do
    first_name              'Joe'
    last_name               'Mechanic'
    email                   'email@host.com'
    password                'password'
    dob                     { 25.years.ago }
    description             'I am a great mechanic'
    location                { create :location, :with_type }
    driver_license_number   'CBN123447765'
    license_state           { State.find_or_create_by(name: 'Queensland') }
    license_expiry          { Time.now + 1.year }
  end
end
