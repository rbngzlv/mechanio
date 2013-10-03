FactoryGirl.define do
  factory :task do
    note 'A note to mechanic'

    factory :service, class: 'Service' do
      type 'Service'
      service_plan
    end

    factory :repair, class: 'Repair' do
      type 'Repair'
      note 'A note to mechanic'
    end
  end
end
