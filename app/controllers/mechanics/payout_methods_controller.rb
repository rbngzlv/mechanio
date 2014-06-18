class Mechanics::PayoutMethodsController < Mechanics::ApplicationController
  before_filter :build_associations

  def edit
    load_paid_jobs
  end

  def update
    if current_mechanic.payout_method.update(permitted_params)
      redirect_to edit_mechanics_payout_method_path, notice: 'Your payout information successfully updated.'
    else
      load_paid_jobs
      render :edit
    end
  end


  private

  def permitted_params
    params.require(:payout_method).permit(:account_name, :account_number, :bsb_number)
  end

  def build_associations
    current_mechanic.build_associations
  end

  def load_paid_jobs
    @paid_jobs = current_mechanic.paid_jobs
  end
end
