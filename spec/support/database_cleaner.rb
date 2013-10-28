RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.before :each do
    DatabaseCleaner.strategy = example.metadata[:js] ? :deletion : :truncation, { except: %w[spatial_ref_sys] }
    DatabaseCleaner.start
  end

  config.after :each do
    DatabaseCleaner.clean
  end
end
