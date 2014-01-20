class Users::ApplicationController < ApplicationController

  layout 'sidebar'

  before_filter :store_location, unless: :user_signed_in?
  before_filter :authenticate_user!
end
