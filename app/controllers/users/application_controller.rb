class Users::ApplicationController < ApplicationController

  layout 'sidebar'

  before_filter :authenticate_user!
end
