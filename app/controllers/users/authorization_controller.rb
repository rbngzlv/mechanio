class Users::AuthorizationController < Devise::SessionsController

  def create
    auth = request.env["omniauth.auth"]
    unless @auth = Authorization.find_from_hash(auth)
      @auth = Authorization.create_from_hash(auth, current_user)
    end
    sign_in_and_redirect(:user, @auth.user)
  end
end
