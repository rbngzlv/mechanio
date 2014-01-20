require 'spec_helper'

feature 'dashboard page' do
  let(:user) { create :user }

  subject { page }

  before do
    login_user user
    visit users_dashboard_path
  end

  it 'shows verified icons' do
    within '.verified-icons' do
      pending 'User mobile and payment method verifications are not implemented yet'

      find('i:nth-child(1)')[:class].should eq ''
      find('i:nth-child(2)')[:class].should eq 'icon-mobile-phone'
      find('i:nth-child(3)')[:class].should eq ''
    end
  end

  context 'should have dynamic content' do
    include_examples("description block") do
      let(:reviews_count) { "Reviews Left: #{user.reviews}" }
      let(:profile) { user }
    end
  end
end
