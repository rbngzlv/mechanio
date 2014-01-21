class Mechanics::ProfilesController < Mechanics::ApplicationController
  def show
  end

  def edit
    current_mechanic.build_locations
  end

  def update
    if current_mechanic.update_attributes(permitted_params)
      redirect_to :back, notice: 'Your profile successfully updated.'
    else
      current_mechanic.build_locations
      render :edit
    end
  end

  private

  def permitted_params
    params.require(:mechanic).permit(
      :first_name, :last_name, :email, :dob, :description,
      :avatar, :mobile_number, :business_name, :abn_number, :abn_expiry,
      :business_website, :business_email, :business_mobile_number, :abn,
      location_attributes: [:address, :suburb, :postcode, :state_id],
      business_location_attributes: [:address, :suburb, :postcode, :state_id]
    )
  end
end
