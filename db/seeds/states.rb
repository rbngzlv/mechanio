states = %w(ACT NSW NT QLD SA TAS VIC WA')
states.each { |s| State.find_or_create_by(name: s) }
