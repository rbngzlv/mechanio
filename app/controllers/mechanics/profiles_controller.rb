class Mechanics::ProfilesController < Mechanics::ApplicationController
  def show
  end

  def edit
    current_mechanic.build_locations
  end

  def update
    if current_mechanic.update_attributes(permitted_params)
      redirect_to mechanics_profile_path, notice: 'Your profile succesfully updated.'
    else
      render :edit
    end
  end

  private

  def permitted_params
    params.require(:mechanic).permit(
      :first_name, :last_name, :email, :dob, :description,
      :driver_license_number, :license_state_id, :license_expiry, :avatar,
      :driver_license, :abn, :mechanic_license, :abn_name,
      :business_website, :business_email, :years_as_a_mechanic, :mobile_number,
      :other_number, :abn_number, :abn_expiry, :mechanic_license_number,
      :mechanic_license_expiry, :mechanic_license_state_id
    )
  end
end
