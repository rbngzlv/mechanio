class Users::ProfilesController < Users::ApplicationController
  def show
  end

  def edit
    current_user.build_location unless current_user.location
  end

  def update
    if current_user.update_attributes(permitted_params)
      redirect_to :back, notice: 'Your profile succesfully updated.'
    else
      render :edit
    end
  end

  private

  def permitted_params
    params.require(:user).permit(
      :first_name, :last_name, :email, :dob, :description, :mobile_number, :avatar,
      { location_attributes: [:address, :suburb, :postcode, :state_id] }
    )
  end
end
