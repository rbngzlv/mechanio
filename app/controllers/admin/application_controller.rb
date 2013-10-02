class Admin::ApplicationController < ApplicationController

  layout :select_layout

  before_filter :authenticate_admin!

  def select_layout
    'admin'
  end
end
