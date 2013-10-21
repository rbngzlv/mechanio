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
    'Broken'
  ],
  'Feels like' => [
    'Vibration'
  ]
}
Symptom.delete_all
symptoms.each do |parent, children|
  s = Symptom.create(description: parent)
  children.each do |c|
    Symptom.create(description: c, parent_id: s.id)
  end
end

Admin.create(email: 'admin@host.com', password: 'password') if Admin.count == 0