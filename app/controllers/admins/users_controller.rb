class Admins::UsersController < Admins::ApplicationController

  before_filter :find_user, only: [:show, :suspend, :activate, :impersonate]

  skip_before_filter :authenticate_admin!, only: [:stop_impersonating]

  def index
    @query = params[:query]
    @users = User.search(@query).order(created_at: :desc).page(params[:page])
  end

  def show
  end

  def suspend
    @user.suspend
    redirect_to admins_users_path, notice: 'User suspended'
  end

  def activate
    @user.activate
    redirect_to admins_users_path, notice: 'User activated'
  end

  def impersonate
    session[:remember_admin_id] = current_admin.id
    sign_out(current_admin)
    sign_in(@user)

    redirect_to root_path
  end

  def stop_impersonating
    admin_id = session.delete(:remember_admin_id)
    redirect_to admins_dashboard_path and return unless admin_id

    admin = Admin.find(admin_id)
    sign_out(current_user)
    sign_in(admin)

    redirect_to admins_users_path
  end

  private

  def find_user
    @user = User.find(params[:id])
  end
end
