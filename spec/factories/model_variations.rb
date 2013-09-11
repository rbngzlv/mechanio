FactoryGirl.define do
  factory :model_variation do
    title        '3dr Hatchback 1.6turbo'
    identifier   'AXC12362324'
    brand
    model
    body_type
    from_year    2010
    to_year      2012
    transmission 'Manual'
    fuel         'Petrol'
  end
end
