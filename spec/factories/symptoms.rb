FactoryGirl.define do
  factory :symptom do
    description 'Drifts - Gradual movements to one side.'
  end

  factory :symptom_tree, class: 'Symptom' do
    description 'Looks like'
    comment 'What do you see?'

    after(:build) do |parent|
      parent.children << build(:symptom, description: 'Smoke', comment: 'Replace the air filter')
      parent.children << build(:symptom, description: 'Poor gas mileage', comment: 'Replace the lambda sensor')
    end
  end
end
