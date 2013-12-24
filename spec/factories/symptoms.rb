FactoryGirl.define do
  factory :symptom do
    description 'Drifts - Gradual movements to one side.'
  end

  factory :symptom_tree, class: 'Symptom' do
    description 'Root'

    after(:create) do |root|
      parent = create(:symptom, description: 'Looks like', parent: root)
      create(:symptom, description: 'Sway - Gradual movement from side to side.', parent: parent)
      create(:symptom, description: 'Drifts - Gradual movements to one side.', parent: parent)
    end
  end
end
