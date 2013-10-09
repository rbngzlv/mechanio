require 'spec_helper'

feature 'dashboard page' do
  let(:user) { create :user }

  subject { page }

  before do
    login_user user
    visit users_dashboard_path
  end

  context 'should have dynamic content' do
    include_examples("description block") do
      let(:reviews_count) { "Reviews Left: #{user.reviews}" }
      let(:profile) { user }
    end
  end
end
