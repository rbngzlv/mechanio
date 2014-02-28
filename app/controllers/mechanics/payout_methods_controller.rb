class Mechanics::PayoutMethodsController < Mechanics::ApplicationController
  def show
  end

  def edit
    current_mechanic.build_associations
  end

  def update
    if current_mechanic.update_attributes(permitted_params)
      redirect_to :back, notice: 'Your payout information successfully updated.'
    else
      current_mechanic.build_associations
      render :edit
    end
  end

  private

  def permitted_params
    params.require(:mechanic).permit(
      payout_method_attributes: [:account_name, :account_number, :bsb_number]
    )
  end
end
