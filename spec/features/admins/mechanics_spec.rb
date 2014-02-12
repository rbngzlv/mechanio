require 'spec_helper'

feature 'Admin mechanics management' do

  let(:mechanic) { create :mechanic, mobile_number: '0410123456' }

  before do
    login_admin
  end

  it 'lists available mechanics' do
    mechanic
    visit admins_mechanics_path

    date_joined = mechanic.created_at.to_s(:date_short)
    page.should have_css 'thead', text: 'Name Email Mobile Current Appts. Completed Jobs Total Earnings Feedback Score Date joined'
    page.should have_css 'tbody tr', text: "#{mechanic.full_name} #{mechanic.email} 0410123456 0 0 $0.00 2 #{date_joined} Edit"
  end

  it 'shows mechanic details' do
    visit edit_admins_mechanic_path(mechanic)

    page.should have_css 'h4', text: 'Mechanic details'
    page.should have_field 'First name', with: mechanic.first_name

    within '.top-bar' do
      page.should have_button 'Save'
    end
    within 'hr + .form-group' do
      page.should have_button 'Save'
    end
  end

  context 'edits existing mechanic' do
    before { mechanic }

    scenario 'success' do
      visit admins_mechanics_path
      page.should have_css 'td', text: 'Joe Mechanic'

      click_link 'Edit'
      fill_in 'First name', with: 'Alex'
      click_save
      page.should have_css '.alert-info', text: 'Mechanic successfully updated.'

      visit admins_mechanics_path
      page.should have_css 'td', text: 'Alex Mechanic'
    end

    scenario 'fail' do
      visit admins_mechanics_path
      click_link 'Edit'
      page.should have_selector "h4", text: "Mechanic details"
      fill_in 'First name', with: ''
      click_save
      page.should have_content "Please review the problems below:"
      page.should have_selector "#mechanic_business_location_attributes_address"
    end
  end

  it 'deletes a mechanic', :js do
    visit edit_admins_mechanic_path(mechanic)

    expect { click_link 'Delete' }.to change { Mechanic.count }.by -1
    page.should have_css '.alert', text: 'Mechanic successfully deleted.'
  end

  context 'suspend a mechanic' do
    it 'success' do
      visit edit_admins_mechanic_path(mechanic)
      expect do
        click_on 'Suspend'
      end.to change { mechanic.reload.suspended_at }.from(nil)
      page.should have_selector '.alert-info', text: 'Mechanic successfully suspended.'
      page.should have_selector '.label', text: "Suspended at #{mechanic.suspended_at.to_s(:date_short)}"
    end

    it 'fail' do
      Mechanic.any_instance.should_receive(:save).and_return(false)
      visit edit_admins_mechanic_path(mechanic)
      expect do
        click_on 'Suspend'
      end.not_to change { mechanic.reload.suspended_at }
      page.should have_selector '.alert-danger', text: 'Error updating mechanic.'
    end
  end

  context 'edit images' do
    let(:image_path) { "#{Rails.root}/spec/features/fixtures/test_img.jpg" }

    scenario 'deleting', :js do
      mechanic.avatar = File.open(image_path)
      mechanic.save
      visit edit_admins_mechanic_path(mechanic)

      page.should have_selector '.file-input-name', text: 'test_img.jpg'
      expect do
        find('span.btn-change-image.btn-delete-image', text: '×').click
        sleep 0.1
      end.to change { mechanic.reload.avatar? }.from(true).to(false)
      page.should have_content 'Image successfully deleted.'
    end

    scenario 'uploading cancel', :js do
      visit edit_admins_mechanic_path(mechanic)
      click_on "Motor Mechanic's License"
      attach_file('mechanic_mechanic_license', image_path)

      page.should have_selector '.file-input-name', text: 'test_img.jpg'
      expect do
        find('span.btn-change-image.btn-cancel-image-upload', text: '×').click
      end.to change { all('.file-input-name').length }.from(1).to(0)
      expect { click_save }.not_to change { all('img').length }
    end
  end

  def click_save
    within 'hr + .form-group' do
      click_button 'Save'
    end
  end
end
