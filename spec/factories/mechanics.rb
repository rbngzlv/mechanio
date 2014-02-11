FactoryGirl.define do
  sequence(:last_name) { |n| "Mechanic#{n}" }

  factory :mechanic do
    first_name              'Joe'
    last_name               { generate(:last_name) }
    email                   { generate(:email) }
    password                'password'
    dob                     { 25.years.ago }
    description             'I am a great mechanic'
    location
    driver_license_number   '12345678'
    license_state           { State.find_or_create_by(name: 'Queensland') }
    license_expiry          { Time.now + 1.year }
    mobile_number           '0420123456'
  end
end
