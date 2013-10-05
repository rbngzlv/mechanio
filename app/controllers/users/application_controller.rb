class Users::ApplicationController < ApplicationController

  layout :select_layout

  before_filter :authenticate_user!

  def select_layout
    'users'
  end
end
