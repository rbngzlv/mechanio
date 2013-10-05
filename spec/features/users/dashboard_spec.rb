require 'spec_helper'

feature 'dashboard page' do
  let(:user) { create :user }

  subject { page }

  before do
    login_user
    visit users_dashboard_path
  end

  context 'should have dinamyc content' do
    it 'default when user is new' do
      should have_selector 'h4', text: user.full_name
      should have_selector 'span', text: "Reviews Left : #{user.reviews}"
      should have_content "Create some description"
    end

    it 'custome when user is edited' do
    end
  end
end
