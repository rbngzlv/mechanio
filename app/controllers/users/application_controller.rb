class Users::ApplicationController < ApplicationController

  layout 'sidebar'

  before_filter :store_location, unless: :user_signed_in?
  before_filter :authenticate_user!

  private

  def store_location
    session[:previous_url] = request.url if request.get?
  end
end
