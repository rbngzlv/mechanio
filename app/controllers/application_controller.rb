class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception


  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :clear_remembered_admin

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:first_name, :last_name, :email, :password)
    end
  end

  def after_sign_in_path_for(resource)
    case
      when resource.instance_of?(Mechanic)  then resource.sign_in_count == 1 ? edit_mechanics_settings_path : mechanics_dashboard_path
      when resource.instance_of?(Admin)     then admins_dashboard_path
      when resource.instance_of?(User)      then session[:tmp_job_id].blank? ? (session.delete(:previous_url) || root_path) : service_path
    end
  end

  def clear_remembered_admin
    session.delete(:remember_admin_id) unless current_user
  end
end
