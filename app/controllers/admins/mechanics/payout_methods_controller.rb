class Admins::Mechanics::PayoutMethodsController < Admins::ApplicationController

  before_filter :find_mechanic

  def edit
    @mechanic.build_associations
  end

  def update
    if @mechanic.update_attributes(permitted_params)
      redirect_to edit_admins_mechanic_payout_method_path(@mechanic), notice: 'Payout information successfully updated.'
    else
      @mechanic.build_associations
      render :edit
    end
  end


  private

  def permitted_params
    params.require(:mechanic).permit(
      payout_method_attributes: [:account_name, :account_number, :bsb_number]
    )
  end

  def find_mechanic
    @mechanic = Mechanic.find(params[:mechanic_id])
  end
end
