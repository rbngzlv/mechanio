class Api::ApplicationController < ApplicationController
  respond_to :json

  # TODO: replace this dummy with real authorized mechanic
  def current_mechanic
    @mechanic ||= Mechanic.first
  end
end

