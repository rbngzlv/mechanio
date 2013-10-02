class Users::JobsController < Users::ApplicationController

  skip_before_filter :authenticate_user!, only: [:new]

  def new
    @job = Job.new
    @user_id = false
    @cars = []

    if user_signed_in?
      @user_id = current_user.id
      @cars = current_user.cars.select([:id, :display_title, :model_variation_id]).all
        .inject({}) { |m, i| m[i.id] = i; m }.to_json
    end
  end

  def create
  end
end
