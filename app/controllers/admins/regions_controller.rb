class Admins::RegionsController < Admins::ApplicationController

  def index
    @regions = Region.roots
  end
end