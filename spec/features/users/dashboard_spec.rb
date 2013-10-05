require 'spec_helper'

feature 'dashboard page' do
  let(:user) { create :user }

  subject { page }

  before do
    login_user
    visit users_dashboard_path
  end

  context 'should have dinamyc content' do
    include_examples("describe") do
      let(:subject) { user }
    end

    specify 'custom when user is edited', pending: 'task: edit user' do
    end
  end
end
