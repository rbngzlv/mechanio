class Users::RegistrationsController < Devise::RegistrationsController
  def new
    build_resource(params[:user] ? params[:user].permit(:email) : {})
    respond_with self.resource
  end
end
