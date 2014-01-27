class Users::AuthenticationsController < Users::ApplicationController
  def destroy
    current_user.authentications.find(params[:id]).destroy
    redirect_to edit_users_profile_path(anchor: 'social-connections'), notice: 'Connection successfully destroyed'
  end
end
