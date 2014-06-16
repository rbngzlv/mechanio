FactoryGirl.define do
  factory :region do
  end

  factory :sydney_region, class: 'Region' do
    name      'Sydney region'
    postcode  nil
  end

  factory :sydney_suburb, class: 'Region' do
    name         'Sydney'
    postcode     '2012'
    display_name 'Sydney, NSW 2012'
  end

  factory :hill_suburb, class: 'Region' do
    name          'The Hill'
    postcode      '2300'
    display_name  'The Hill, NSW 2300'
  end

  factory :regions_tree, class: 'Region' do
    name 'Root'

    after(:create) do |root|
      state = create(:region, name: 'NSW', parent: root)
      region = create(:sydney_region, parent: state)
      suburb = create(:sydney_suburb, parent: region)
    end
  end
end
