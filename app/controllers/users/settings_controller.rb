class Users::SettingsController < Users::ApplicationController
  def edit
  end

  def update
    attrs = params[:user].permit(:password, :password_confirmation, :current_password)
    if current_user.update_with_password(attrs)
      sign_in current_user, bypass: true
      redirect_to edit_users_settings_path, notice: 'Your password successfully updated.'
    else
      render :edit
    end
  end
end
