module FeatureMacros

  include Warden::Test::Helpers
  Warden.test_mode!

  def login_user(user = nil)
    user ||= create :user
    login_as user, scope: :user
  end
end
