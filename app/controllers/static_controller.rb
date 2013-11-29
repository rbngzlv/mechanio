class StaticController < ApplicationController
  def about_us
    render layout: "no_container"
  end
  def home_page
    render layout: "no_container"
  end
end
