class PagesController < ApplicationController
  include HighVoltage::StaticPage

  layout :layout_for_page

  private

  def layout_for_page
    case params[:id]
      when 'home' then 'no_container'
      when 'about_us' then 'no_container'
      else 'application'
    end
  end
end
