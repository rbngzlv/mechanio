class Admins::UsersController < Admins::ApplicationController

  before_filter :find_user, only: [:show, :suspend, :activate]

  def index
    @query = params[:query]
    @users = User.order(created_at: :desc).page(params[:page])
    @users = @users.fuzzy_search(@query) unless @query.blank?
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


  private

  def find_user
    @user = User.find(params[:id])
  end
end
