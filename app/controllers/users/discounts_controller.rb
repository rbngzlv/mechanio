class Users::DiscountsController < ApplicationController

  def create
    @job = Job.find(params[:job_id])

    if discount_service.call
      flash[:success] = 'Discount successfully applied'
    else
      flash[:error] = discount_service.errors.full_messages.join("\n")
    end

    redirect_to new_users_job_credit_card_path(@job)
  end


  private

  def discount_service
    @discount_service ||= Jobs::ApplyDiscount.new(@job, permitted_params[:code])
  end

  def permitted_params
    params.require(:discount).permit(:code)
  end
end
