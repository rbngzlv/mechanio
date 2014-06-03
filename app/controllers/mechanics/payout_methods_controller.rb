class Mechanics::PayoutMethodsController < Mechanics::ApplicationController
  def edit
    current_mechanic.build_associations
    load_paid_jobs
  end

  def update
    if current_mechanic.update_attributes(permitted_params)
      redirect_to edit_mechanics_payout_method_path, notice: 'Your payout information successfully updated.'
    else
      current_mechanic.build_associations
      load_paid_jobs
      render :edit
    end
  end


  private

  def permitted_params
    params.require(:mechanic).permit(
      payout_method_attributes: [:account_name, :account_number, :bsb_number]
    )
  end

  def load_paid_jobs
    @paid_jobs = current_mechanic.paid_jobs
  end
end
