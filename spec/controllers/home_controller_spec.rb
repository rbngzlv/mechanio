require 'spec_helper'

describe HomeController do

  it 'responds successfully' do
    get :index

    response.should be_success
  end
end
