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
    respond_with self.resource
  end
end
