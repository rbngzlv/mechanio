class Admins::RegionsController < Admins::ApplicationController

  def index
    @states = State.all
    @regions = Region.roots
  end
end