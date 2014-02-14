class Admins::PayoutMethodsController < Admins::ApplicationController
#     admins_mechanic_payout_methods POST     /admins/mechanics/:mechanic_id/payout_methods(.:format)          admins/payout_methods#create
#  new_admins_mechanic_payout_method GET      /admins/mechanics/:mechanic_id/payout_methods/new(.:format)      admins/payout_methods#new
# edit_admins_mechanic_payout_method GET      /admins/mechanics/:mechanic_id/payout_methods/:id/edit(.:format) admins/payout_methods#edit
#      admins_mechanic_payout_method PATCH    /admins/mechanics/:mechanic_id/payout_methods/:id(.:format)      admins/payout_methods#update
#                                    PUT      /admins/mechanics/:mechanic_id/payout_methods/:id(.:format)      admins/payout_methods#update
#                                    DELETE   /admins/mechanics/:mechanic_id/payout_methods/:id(.:format)      admins/payout_methods#destroy
  before_action :find_mechanic
  # TODO: bad name for method, because active record has compared method
  # before_action :build_payout_method

  def new
    @payout_method = @mechanic.payout_methods.build
  end

  def create
    @payout_method = @mechanic.payout_methods.build(payout_method_params)
    if @payout_method.save
      redirect_to edit_admins_mechanic_path(@mechanic), notice: 'Payout method successfully added.'
    else
      render :new
    end
  end

  def edit
    @payout_method = @mechanic.payout_methods.find(params[:id])
  end

  def update
    @payout_method = @mechanic.payout_methods.find(params[:id])
    if @payout_method.update_attributes(payout_method_params)
      redirect_to edit_admins_mechanic_path(@mechanic), notice: 'Payout method successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @mechanic.payout_methods.find(params[:id]).destroy
    redirect_to edit_admins_mechanic_path(@mechanic), notice: 'Payout method successfully deleted.'
  end

  private

  # TODO: I can move this method into observer
  def find_mechanic
    @mechanic = Mechanic.find(params[:mechanic_id])
  end

  def payout_method_params
    params.require(:payout_method).permit(:account_name, :account_number, :bsb_number)
  end
end
