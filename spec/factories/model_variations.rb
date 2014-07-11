FactoryGirl.define do
  factory :model_variation do
    make
    model
    title        '2.0 Litre 9C SOHC'
    identifier   'AXC12362324'
    shape        'Sedan'
    from_year    2010
    to_year      2012
    transmission 'Manual'
    fuel         'Petrol'
  end
end
