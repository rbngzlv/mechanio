require 'spec_helper'

describe Admin::DashboardController do

  it 'redirects when not logged in' do
    get :index

    response.should redirect_to new_admin_session_path
  end

  it 'is succesfull when logged in' do
    login_admin
    get :index

    response.should be_success
  end
end
