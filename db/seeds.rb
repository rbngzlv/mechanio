states = %w(ACT NSW NT QLD SA TAS VIC WA')
states.each { |s| State.find_or_create_by(name: s) }

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
root = Symptom.find_or_create_by(description: 'Root')
symptoms.each do |parent, children|
  s = root.children.find_or_create_by(description: parent)
  children.each do |c|
    s.children.find_or_create_by(description: c)
  end
end

Admin.create(email: 'admin@host.com', password: 'password') if Admin.count == 0