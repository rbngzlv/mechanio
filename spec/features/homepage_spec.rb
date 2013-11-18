require 'spec_helper'

describe 'Homepage' do
  before { visit root_path }

  subject { page }

  it 'shows homepage' do
    should have_link 'Sign up'
    should have_link 'Login'
    should have_content 'Book professional mobile mechanics to service or repair your car at your convenience'
  end

  it 'has feature to prefill email for signup page' do
    fill_in 'youremail@address.com', with: 'prefill_test@example.com'
    click_button 'SIGN UP'
    find_field('user_email').value.should eq 'prefill_test@example.com'
  end
end
