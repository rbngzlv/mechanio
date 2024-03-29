class Users::RegistrationsController < Devise::RegistrationsController
  def new
    hash = case
      when params[:user] then params[:user].permit(:email)
      when session["devise.oauth_data"] then
        data = session["devise.oauth_data"]['info']
        { email: data['email'], first_name: data['first_name'], last_name: data['last_name'] }
      else {}
    end
    build_resource hash
    self.resource.build_location
    respond_with self.resource
  end

  def sign_up(resource_name, resource)
    Users::PostSignup.new(resource, session).call
    sign_in(resource_name, resource)
  end


  private

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, location_attributes: [:suburb])
  end
end
