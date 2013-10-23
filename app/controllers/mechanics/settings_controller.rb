class Mechanics::SettingsController < Mechanics::ApplicationController
  def edit
  end

  def update
    attrs = params[:mechanic].permit(:password, :password_confirmation, :current_password)
    if current_mechanic.update_with_password(attrs)
      sign_in current_mechanic, bypass: true
      redirect_to edit_mechanics_settings_path, notice: 'Your password successfully updated.'
    else
      render :edit
    end
  end
end
