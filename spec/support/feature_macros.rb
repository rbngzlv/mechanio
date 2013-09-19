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

  def screenshot
    @index ||= 1
    page.save_screenshot("/Users/bob/Desktop/screen-#{@index}.png", full: true)
  end
end
