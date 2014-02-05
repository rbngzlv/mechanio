class Users::AuthenticationsController < Users::ApplicationController
  def destroy
    auth = current_user.authentications.find(params[:id])
    provider = auth.provider_name
    auth.destroy
    flash[:notice] = "#{provider} connection removed"
    redirect_to edit_users_profile_path(anchor: 'social-connections')
  end
end
