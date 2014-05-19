class Admins::UsersController < Admins::ApplicationController

  before_filter :find_user, only: [:show, :destroy]

  def index
    @query = params[:query]
    @users = User.order(created_at: :desc).page(params[:page])
    @users = @users.fuzzy_search(@query) if @query
  end

  def show
  end

  def destroy
    @user.destroy
    redirect_to admins_users_path, notice: "User successfully deleted."
  end


  private

  def find_user
    @user = User.find(params[:id])
  end
end
