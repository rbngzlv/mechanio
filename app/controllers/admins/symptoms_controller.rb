class Admins::SymptomsController < Admins::ApplicationController

  before_filter :find_symptom, except: [:index, :new, :create]

  def index
    @symptoms = Symptom.tree
  end

  def new
    @symptom = Symptom.new
  end

  def edit
  end

  def create
    @symptom = Symptom.new(permitted_params)
    if @symptom.save
      redirect_to admins_symptoms_path, notice: 'Symptom created successfully'
    else
      render :new
    end
  end

  def update
    if @symptom.update_attributes(permitted_params)
      redirect_to admins_symptoms_path, notice: 'Symptom updated successfully'
    else
      render :new
    end
  end

  def destroy
    @symptom.destroy
    redirect_to admins_symptoms_path, notice: 'Symptom(s) deleted successfully'
  end

  private

  def permitted_params
    attrs = params.require(:symptom).permit(:description, :comment, :parent_id)
    attrs
  end

  def find_symptom
    @symptom = Symptom.find(params[:id])
  end
end
