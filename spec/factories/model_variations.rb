FactoryGirl.define do
  factory :model_variation do
    title        '2.0 Litre 9C SOHC'
    identifier   'AXC12362324'
    make
    model
    body_type
    from_year    2010
    to_year      2012
    transmission 'Manual'
    fuel         'Petrol'
  end
end
