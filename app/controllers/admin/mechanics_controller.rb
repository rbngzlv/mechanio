class Admin::MechanicsController < Admin::ApplicationController

  before_filter :find_mechanic, only: [:edit, :update, :destroy]

  def index
    @mechanics = Mechanic.order(created_at: :desc).page(params[:page])
  end

  def new
    @mechanic = Mechanic.new
    build_associations
  end

  def create
    password = Devise.friendly_token.first(8)
    @mechanic = Mechanic.new(permitted_params.merge(password: password))

    if @mechanic.save
      registration_email @mechanic
      redirect_to edit_admin_mechanic_path(@mechanic), notice: 'Mechanic succesfully created.'
    else
      render :new
    end
  end

  def edit
    build_associations
  end

  def update
    if @mechanic.update_attributes(permitted_params)
      redirect_to edit_admin_mechanic_path(@mechanic), notice: 'Mechanic succesfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @mechanic.destroy
    redirect_to admin_mechanics_path, notice: 'Mechanic succesfully deleted.'
  end


  private

  def find_mechanic
    @mechanic = Mechanic.find(params[:id])
  end

  def build_associations
    @mechanic.build_location            unless @mechanic.location
    @mechanic.build_business_location   unless @mechanic.business_location
  end

  def permitted_params
    params.require(:mechanic).permit!
  end

  def registration_email(mechanic)
    MechanicMailer::registration_note(mechanic).deliver
  end
end
