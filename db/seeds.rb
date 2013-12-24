State.delete_all

states = [
  'ACT',
  'NSW',
  'NT',
  'QLD',
  'SA',
  'TAS',
  'VIC',
  'WA'
]

states.each do |s|
  State.create(name: s)
end

symptoms = {
  'Looks like' => [
    'Drifts - Gradual movements to one side.',
    'Excessive play - Looseness, lack of response in the steering wheel.',
    'Pulls - Sharp movement to one side.',
    'Pulsation - Fluctuation of the brake pedal when the brakes are applied.',
    'Shimmy - Rapid side to side movement of the front wheels.',
    'Sway - Gradual movement from side to side.',
    'Vibration- Vehicle shakes. Ususally felt in the steering wheel or the seat.'
  ],
  'Sounds like' => [
    'Drifts - Gradual movements to one side.',
    'Excessive play - Looseness, lack of response in the steering wheel.',
    'Pulls - Sharp movement to one side.',
    'Pulsation - Fluctuation of the brake pedal when the brakes are applied.',
    'Shimmy - Rapid side to side movement of the front wheels.',
    'Sway - Gradual movement from side to side.',
    'Vibration- Vehicle shakes. Ususally felt in the steering wheel or the seat.'
  ],
  'Smells like' => [],
  'Feels like' => [],
  'Not working' => []
}
Symptom.delete_all
root = Symptom.create(description: 'Root')
symptoms.each do |parent, children|
  s = Symptom.create(description: parent, parent: root)
  children.each do |c|
    Symptom.create(description: c, parent: s)
  end
end

Admin.create(email: 'admin@host.com', password: 'password') if Admin.count == 0