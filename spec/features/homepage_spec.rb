require 'spec_helper'

describe 'Homepage' do

  it 'shows homepage' do
    visit root_path

    page.should have_link 'Sign up'
    page.should have_link 'Login'
    page.should have_content 'Book professional mobile mechanics to service or repair your car at your conveniene'
  end
end
