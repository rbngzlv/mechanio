Dir[File.join(Rails.root, 'db', 'seeds', '**/*.rb')].each { |f| require f }
