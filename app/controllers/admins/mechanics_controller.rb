class Admins::MechanicsController < Admins::ApplicationController

  before_filter :find_mechanic, except: [:index, :new, :create]

  def index
    @mechanics = Mechanic.order(created_at: :desc).page(params[:page])
  end

  def new
    @mechanic = Mechanic.new
    @mechanic.build_locations
  end

  def create
    password = Devise.friendly_token.first(8)
    @mechanic = Mechanic.new(permitted_params.merge(password: password))

    if @mechanic.save
      registration_email @mechanic, password
      redirect_to edit_admins_mechanic_path(@mechanic), notice: 'Mechanic successfully created.'
    else
      @mechanic.build_locations
      render :new
    end
  end

  def edit
    @mechanic.build_locations
  end

  def update
    if @mechanic.update_attributes(permitted_params)
      redirect_to edit_admins_mechanic_path(@mechanic), notice: 'Mechanic successfully updated.'
    else
      @mechanic.build_locations
      render :edit
    end
  end

  def destroy
    @mechanic.destroy
    redirect_to admins_mechanics_path, notice: 'Mechanic successfully deleted.'
  end

  def edit_regions
  end

  def update_regions
    region_ids = Region.find(params[:region_id]).subtree_ids
    @mechanic.toggle_regions(region_ids, params[:toggle] == 'true')
    render text: region_ids.inspect
  end

  def regions_subtree
    root = Region.find(params[:region_id])
    render text: view_context.regions_tree(root, selected: @mechanic.region_ids)
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
