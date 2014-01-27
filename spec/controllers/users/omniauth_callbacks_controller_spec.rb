require 'spec_helper'

describe Users::OmniauthCallbacksController do
  it do
    get user_omniauth_authorize_path(:facebook)
    response.should redirect_to 'http://facebook'
  end
end
