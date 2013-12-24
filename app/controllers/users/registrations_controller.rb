class Users::RegistrationsController < Devise::RegistrationsController
  def new
    build_resource(if params[:user]
      params[:user].permit(:email)
    elsif session["devise.oauth_data"]
      data = session["devise.oauth_data"]['info']
      {
        email: data['email'],
        first_name: data['first_name'],
        last_name: data['last_name']
      }
    else
      {}
    end)
    respond_with self.resource
  end
end
