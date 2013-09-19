class Mechanics::ApplicationController < ApplicationController

  before_filter :authenticate_mechanic!

end
