module FeatureMacros

  include Warden::Test::Helpers
  Warden.test_mode!

  def login_user(user = nil)
    user ||= create :user
    login_as user, scope: :user
  end

  def login_admin(admin = nil)
    admin ||= create :admin
    login_as admin, scope: :admin
  end

  def login_mechanic(mechanic = nil)
    mechanic ||= create :mechanic
    login_as mechanic, scope: :mechanic
  end

  def autocomplete(field, type_text, select_option)
    page.execute_script "$('input.sfTypeahead, input.suburb-typeahead').unbind('blur')"
    fill_in field, with: type_text
    find('.tt-dropdown-menu p', text: select_option).click
  end
end
