class Admins::DiscountsController < Admins::ApplicationController
  before_filter :find_discount, only: [:edit, :update, :destroy]

  def index
    @query     = params[:query]
    @discounts = Discount.search(@query).page(params[:page])
  end

  def new
    @discount = Discount.new
  end

  def create
    @discount = Discount.new(permitted_parms)
    if @discount.save
      flash[:notice] = 'Discount successfully created'
      redirect_to action: :index
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @discount.update_attributes(permitted_parms)
      flash[:notice] = 'Discount successfully updated'
      redirect_to action: :index
    else
      render :edit
    end
  end

  def destroy
    @discount.destroy
    redirect_to admins_discounts_path, notice: 'Discount successfully deleted'
  end


  private

  def find_discount
    @discount = Discount.find(params[:id])
  end

  def permitted_parms
    params.require('discount').permit(:title, :code, :discount_type, :discount_value, :uses_left, :starts_at, :ends_at)
  end
end
