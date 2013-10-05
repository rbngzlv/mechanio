require 'spec_helper'

feature 'user profile' do
  let(:user) { create :user }

  before do
    login_user
  end

  context 'view page' do
    context 'describe block show' do
      before do
        visit users_dashboard_path
        within('.wrap > .container') { click_link 'My Profile' }
      end

      include_examples("describe") do
        let(:subject) { user }
      end
    end

    it 'does show left commetns', pending: 'do it after create comment model'
  end

  context 'edit', pending: 'task: edit user' do
  end
end
