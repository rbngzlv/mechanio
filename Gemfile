source 'http://rubygems.org'

ruby '2.0.0'

gem 'rails', '4.0.0'
gem 'pg'
gem 'devise'
gem 'carrierwave'
gem 'mini_magick'
gem 'exception_notification'

gem 'haml-rails'
gem 'sass-rails', '~> 4.0.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'bootstrap-sass-rails'
gem 'uglifier', '>= 1.3.0'
gem 'simple_form', '~> 3.0.0.rc'
gem 'kaminari'
gem 'ancestry'
gem 'tlsmail', git: 'https://github.com/benjohnstonsf/tlsmail.git'
gem 'resque'
gem 'resque_mailer'
gem 'geocoder'
gem 'font-awesome-rails'
gem 'state_machine'
gem 'braintree'
gem 'fullcalendar-rails'
gem 'ice_cube'
gem 'high_voltage'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'dotenv-rails'

group :development do
  gem 'letter_opener'
  gem 'pry'
end

group :test do
  gem 'rspec-rails'
  gem 'rspec_api_documentation'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'vcr'
  gem 'webmock'
  gem 'simplecov', require: false
end

group :development, :test do
  gem 'quiet_assets'
  gem 'awesome_print'
end

group :production do
  gem 'unicorn'
end

group :deploy do
  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'rvm-capistrano'
  gem 'capistrano-resque', github: 'sshingler/capistrano-resque'
  gem 'guard'
  gem 'guard-rspec'
end
