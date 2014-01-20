FactoryGirl.define do
  factory :symptom do
    description 'Drifts - Gradual movements to one side.'
  end

  factory :symptom_tree, class: 'Symptom' do
    description 'Looks like'
    comment 'What do you see?'

    after(:build) do |parent|
      parent.children << build(:symptom, description: 'Smoke')
      parent.children << build(:symptom, description: 'Poor gas mileage')
    end
  end
end
