require 'spec_helper'

describe 'Homepage' do
  it 'shows homepage' do
    visit '/'

    page.should have_link 'Sign up'
    page.should have_link 'Login'
    page.should have_content 'Service your car conveniently with reliable mechanic'
  end
end
