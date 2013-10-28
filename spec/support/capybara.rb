require 'capybara/rails'
require 'capybara/poltergeist'

Capybara.javascript_driver = :poltergeist
Capybara.server do |app, port|
  require 'rack/handler/webrick'
  Rack::Handler::WEBrick.run(app, :Port => port, :DoNotReverseLookup => true, :AccessLog => [], :Logger => WEBrick::Log::new(nil, 0))
end
