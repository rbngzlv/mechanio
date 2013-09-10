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
end
