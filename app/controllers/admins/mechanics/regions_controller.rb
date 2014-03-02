class Admins::Mechanics::RegionsController < Admins::ApplicationController

  before_filter :find_mechanic

  def edit
  end

  def update
    region_ids = Region.find(params[:region_id]).subtree_ids
    @mechanic.toggle_regions(region_ids, params[:toggle] == 'true')
    render text: region_ids.inspect
  end

  def subtree
    root = Region.find(params[:region_id])
    render text: view_context.regions_tree(root, selected: @mechanic.region_ids)
  end


  private

  def find_mechanic
    @mechanic = Mechanic.find(params[:mechanic_id])
  end
end
