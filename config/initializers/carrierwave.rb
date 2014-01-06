CarrierWave.configure do |config|
  config.asset_host ||= Capybara.default_host if Rails.env.test?
end
