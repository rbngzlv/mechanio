require 'spec_helper'

describe Users::DashboardController do
  it 'redirects when not logged in' do
    get :index

    response.should redirect_to new_user_session_path
  end

  it 'is succesfull when logged in' do
    login_user
    get :index

    response.should be_success
  end
end
