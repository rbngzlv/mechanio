class Users::AuthenticationsController < Users::ApplicationController
  def destroy
    auth = current_user.authentications.find(params[:id]).destroy
    redirect_to edit_users_profile_path(anchor: 'social-connections'), notice: "#{auth.provider_name} connection removed"
  end
end
