class Admin::RegionsController < Admin::ApplicationController

  def index
    @states = State.all
    @regions = Region.roots
  end
end