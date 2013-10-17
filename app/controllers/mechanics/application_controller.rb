class Mechanics::ApplicationController < ApplicationController

  layout 'sidebar'

  before_filter :authenticate_mechanic!
end
