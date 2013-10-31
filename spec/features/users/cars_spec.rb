require 'spec_helper'

feature 'my cars page' do
  let(:user) { create :user }
  let!(:car1) { create :car, user: user, display_title: 'Audi' }
  let!(:car2) { create :car, user: user, display_title: 'Mercedes' }

  subject { page }

  before do
    login_user user
  end

  specify 'it should show my cars list' do
    visit users_dashboard_path
    within('.nav-stacked') { click_link 'My Cars' }
    current_path.should be_eql users_cars_path
    should have_selector('li.active', text: 'My Cars')
    within '.cars-list' do
      should have_selector('li:nth-child(1)', text: car1.display_title)
      should have_selector('li:nth-child(2)', text: car2.display_title)
    end
  end

  specify 'deleting car' do
    visit users_cars_path
    expect { within('.cars-list li:nth-child(1)') { click_on 'Delete' } }.not_to change(Car.with_deleted, :count)
    should have_no_content car1.display_title
    should have_selector 'li:nth-child(1)', text: car2.display_title
  end
end
