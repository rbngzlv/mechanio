class Users::ProfilesController < Users::ApplicationController
  def show
  end

  def edit
  end

  def update
    if current_user.update_attributes(permitted_params)
      redirect_to users_profile_path, notice: 'Your profile succesfully updated.'
    else
      render :edit
    end
  end

  private

  def permitted_params
    params.require(:user).permit(
      :first_name, :last_name, :email, :dob,
      :description, :mobile_number, :avatar
    )
  end
end
