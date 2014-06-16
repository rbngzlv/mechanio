FactoryGirl.define do
  factory :region do
  end

  factory :sydney_region, class: 'Region' do
    name      'Sydney region'
    postcode  nil
  end

  factory :sydney_suburb, class: 'Region' do
    name      'Sydney'
    postcode  '2012'
  end

  factory :hill_suburb, class: 'Region' do
    name      'The Hill'
    postcode  '2300'
  end

  factory :regions_tree, class: 'Region' do
    name 'NSW'

    after(:create) do |state|
      region = create(:sydney_region, parent: state)
      suburb = create(:sydney_suburb, parent: region)
    end
  end
end
