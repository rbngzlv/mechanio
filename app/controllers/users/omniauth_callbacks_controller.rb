class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    auth = request.env["omniauth.auth"]
    unless @auth = Authorization.find_from_hash(auth)
      @auth = Authorization.create_from_hash(auth, current_user)
    end

    if @auth.user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      sign_in_and_redirect @auth.user, :event => :authentication
    else
      session["devise.google_data"] = auth
      redirect_to new_user_registration_url
    end
  end

  def facebook
    auth = request.env["omniauth.auth"]
    unless @auth = Authorization.find_from_hash(auth)
      @auth = Authorization.create_from_hash(auth, current_user)
    end

    if @auth.user.persisted?
      sign_in_and_redirect @auth.user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = auth
      redirect_to new_user_registration_url
    end
  end
end
