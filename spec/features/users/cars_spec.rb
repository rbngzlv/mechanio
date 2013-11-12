require 'spec_helper'

feature 'my cars page' do
  let(:user) { create :user }
  let!(:car1) { create :car, user: user }
  let!(:car2) { create(:job_with_service, user: user).car }

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
      should_display_cars(car1, car2)
    end
  end

  context 'deleting car' do
    specify 'it is soft' do
      visit users_cars_path
      car1.reload.deleted_at.should be_nil
      expect { within('.cars-list li:nth-child(1)') { click_on 'Delete' } }.to change { user.cars.reload.length }

      car1.reload.deleted_at.should_not be_nil
      should have_no_content car1.display_title
      should_display_cars(car2)
      should have_no_selector '.alert.alert-danger'
    end

    specify 'it validates by opened job' do
      visit users_cars_path
      expect { within('.cars-list li:nth-child(2)') { click_on 'Delete' } }.not_to change { user.cars.reload.length }
      should_display_cars(car1, car2)
      should have_selector '.alert.alert-danger', text: 'Cannot delete a car that has active jobs.'
    end
  end

  def should_display_cars(*cars)
    cars.each_with_index do |car, index|
      should have_selector "li:nth-child(#{ index + 1 })", text: car.display_title
    end
  end
end
