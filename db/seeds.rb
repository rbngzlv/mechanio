State.delete_all

states = [
  'Australian Capital Territory',
  'New South Wales',
  'Northern Territory',
  'Queensland',
  'South Australia',
  'Tasmania',
  'Victoria',
  'Western Australia'
]

states.each do |s|
  State.create(name: s)
end
