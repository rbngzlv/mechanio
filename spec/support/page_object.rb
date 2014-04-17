class PageObject
  include Capybara::DSL
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::NumberHelper
end
