class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def google_oauth2
    connect
  end

  def facebook
    connect
  end

  private

  def connect
    data = request.env['omniauth.auth']
    @auth = Authentication.connect(data, current_user)

    if @auth.error == :already_connected
      set_flash_message(:alert, :already_connected, kind: @auth.provider_name)
      redirect_to edit_users_profile_path(anchor: 'social-connections')
      return
    end

    if @auth.error == :user_invalid
      session['devise.oauth_data'] = data
      redirect_to new_user_registration_url, alert: 'Error occurred'
      return
    end

    if current_user
      set_flash_message(:success, :add_connection, kind: @auth.provider_name)
      redirect_to edit_users_profile_path(anchor: 'social-connections')
    else
      set_flash_message(:notice, :success, kind: @auth.provider_name)
      sign_in_and_redirect @auth.user, event: :authentication
    end
  end
end
