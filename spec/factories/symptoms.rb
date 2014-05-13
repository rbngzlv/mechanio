FactoryGirl.define do
  factory :symptom do
    description 'Drifts - Gradual movements to one side.'
  end

  factory :symptom_tree, class: 'Symptom' do
    description 'Root'

    after(:create) do |root|
      parent = create(:symptom, description: 'Break Problems', comment: 'What is wrong with the breaks?', parent: root)
      create(:symptom, description: 'Break safety inspection', comment: 'Replace the break pads', parent: parent)
      create(:symptom, description: 'Break Pedal is hard to push', comment: 'Replace the vacuum pump', parent: parent)
    end
  end
end
