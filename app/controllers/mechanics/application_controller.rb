class Mechanics::ApplicationController < ApplicationController

  layout :select_layout

  before_filter :authenticate_mechanic!

  def select_layout
    'mechanics'
  end
end
