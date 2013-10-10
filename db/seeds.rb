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

Admin.create(email: 'admin@host.com', password: 'password') if Admin.count == 0