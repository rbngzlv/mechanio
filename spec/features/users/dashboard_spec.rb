require 'spec_helper'

feature 'dashboard page' do
  let(:user) { create :user }

  subject { page }

  before do
    login_user
    visit users_dashboard_path
  end

  context 'should have dinamyc content' do
    include_examples("description block") do
      let(:object) { user }
    end
  end
end
