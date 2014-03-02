class Admins::MechanicsController < Admins::ApplicationController

  before_filter :find_mechanic, except: [:index, :new, :create]

  def index
    @mechanics = Mechanic.order(created_at: :desc).page(params[:page])
  end

  def new
    @mechanic = Mechanic.new
    @mechanic.build_associations
  end

  def create
    password = Devise.friendly_token.first(8)
    @mechanic = Mechanic.new(permitted_params.merge(password: password))

    if @mechanic.save
      registration_email @mechanic, password
      redirect_to edit_admins_mechanic_path(@mechanic), notice: 'Mechanic successfully created.'
    else
      @mechanic.build_associations
      render :new
    end
  end

  def edit
    @mechanic.build_associations
  end

  def update
    if @mechanic.update_attributes(permitted_params)
      redirect_to edit_admins_mechanic_path(@mechanic), notice: 'Mechanic successfully updated.'
    else
      @mechanic.build_associations
      render :edit
    end
  end

  def destroy
    @mechanic.destroy
    redirect_to admins_mechanics_path, notice: 'Mechanic successfully deleted.'
  end

  def suspend
    if @mechanic.suspend
      redirect_to edit_admins_mechanic_path(@mechanic), notice: 'Mechanic successfully suspended.'
    else
      flash[:error] = 'Error updating mechanic.'
      render :edit
    end
  end

  def activate
    if @mechanic.activate
      redirect_to edit_admins_mechanic_path(@mechanic), notice: 'Mechanic successfully activated.'
    else
      flash[:error] = 'Error updating mechanic.'
      render :edit
    end
  end

  private

  def find_mechanic
    @mechanic = Mechanic.find(params[:id] || params[:mechanic_id])
  end

  def permitted_params
    params.require(:mechanic).permit!
  end

  def registration_email(mechanic, password)
    MechanicMailer::registration_note(mechanic.id, password).deliver
  end
end
