class StaticController < ApplicationController
  def about_us
    render layout: "homepage"
  end
  def home_page
    render layout: "homepage"
  end
end
