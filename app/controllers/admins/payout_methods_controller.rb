class Admins::PayoutMethodsController < Admins::ApplicationController
  before_action :find_mechanic
  before_action :find_payout, only: [:edit, :update, :destroy]

  def index
  end

  def new
    @payout_method = @mechanic.payout_methods.build
  end

  def create
    @payout_method = @mechanic.payout_methods.build(payout_method_params)
    if @payout_method.save
      redirect_to admins_mechanic_payout_methods_path(@mechanic), notice: 'Payout method successfully added.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @payout_method.update_attributes(payout_method_params)
      redirect_to admins_mechanic_payout_methods_path(@mechanic), notice: 'Payout method successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @payout_method.destroy
    redirect_to admins_mechanic_payout_methods_path(@mechanic), notice: 'Payout method successfully deleted.'
  end

  private

  def find_mechanic
    @mechanic = Mechanic.find(params[:mechanic_id])
  end

  def find_payout
    @payout_method = @mechanic.payout_methods.find(params[:id])
  end

  def payout_method_params
    params.require(:payout_method).permit(:account_name, :account_number, :bsb_number)
  end
end
