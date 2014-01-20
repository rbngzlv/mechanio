require 'spec_helper'

feature 'Admin mechanics management' do

  let!(:mechanic) { create :mechanic }

  before do
    login_admin
  end

  it 'lists available mechanics' do
    mechanic.mobile_number = '0410123456'
    mechanic.save
    create(:job_with_service, :completed, mechanic: mechanic)
    create(:job_with_service, :confirmed, mechanic: mechanic)
    create(:job_with_service, :assigned, mechanic: mechanic)
    visit admins_mechanics_path

    page.should have_css 'td', text: mechanic.full_name
    page.should have_css 'th:nth-child(3)', text: 'Total Earnings'
    page.should have_css 'th:nth-child(4)', text: 'Average Feedback Score'
    page.should have_css 'th:nth-child(5)', text: 'Mobile Number'
    within 'tbody' do
      page.should have_css 'tr:nth-child(1) td:nth-child(2)', text: '0'
      page.should have_css 'tr:nth-child(1) td:nth-child(3)', text: '0$'
      page.should have_css 'tr:nth-child(1) td:nth-child(4)', text: '2'
      page.should have_css 'tr:nth-child(1) td:nth-child(5)', text: '0410123456'
    end
  end

  it 'shows mechanic details' do
    visit edit_admins_mechanic_path(mechanic)

    page.should have_css 'h4', text: 'Mechanic details'
    page.should have_field 'First name', with: mechanic.first_name
  end

  context 'adds a new mechanic' do
    scenario 'success' do
      mail_deliveries.clear
      visit admins_mechanics_path
      click_link 'Add mechanic'

      expect do
        fill_in 'First name', with: 'First'
        fill_in 'Last name', with: 'Last'
        fill_in 'Email Address', with: 'mechanic@host.com'
        select '1975',    from: 'mechanic_dob_1i'
        select 'October', from: 'mechanic_dob_2i'
        select '1',       from: 'mechanic_dob_3i'
        fill_in 'Personal description', with: 'Something about me'
        fill_in 'mechanic_location_attributes_address', with: 'Seashell avenue, 25'
        fill_in 'mechanic_location_attributes_suburb', with: 'Somewhere'
        select 'Queensland', from: 'mechanic_location_attributes_state_id'
        fill_in 'mechanic_location_attributes_postcode', with: 'AX12345'
        fill_in 'Mobile number', with: '0410123456'
        fill_in "License number", with: 'MXF123887364'
        select 'Queensland', from: "mechanic_license_state_id"
        select '2015',      from: 'mechanic_license_expiry_1i'
        select 'September', from: 'mechanic_license_expiry_2i'
        select '1',         from: 'mechanic_license_expiry_3i'
        click_button 'Save'
      end.to change { Mechanic.count }.by 1

      page.should have_css '.alert', text: 'Mechanic successfully created.'
      last_delivery.body.should include('mechanic@host.com')
      last_delivery.subject.should include('Welcome to Mechanio')
    end

    scenario 'fail' do
      visit admins_mechanics_path
      click_link 'Add mechanic'
      page.should have_selector "h4", text: 'Add mechanic'
      page.should have_selector "legend", text: "Mechanic Details"
      within '.mechanic_location_address' do
        page.should have_selector 'abbr', text: '*'
      end
      within '.mechanic_business_location_address' do
        page.should have_no_selector 'abbr', text: '*'
      end
      click_button 'Save'
      page.should have_content "Please review the problems below:"
      page.should have_selector "#mechanic_business_location_attributes_address"
    end
  end

  context 'edits existing mechanic' do
    scenario 'success' do
      visit admins_mechanics_path
      page.should have_css 'td', text: 'Joe Mechanic'

      click_link 'Edit'
      page.should have_content 'Business Details'
      page.should have_content 'Verified Statuses'
      check 'Phone verified'
      check 'Super mechanic'
      check 'Warranty covered'
      check 'Qualification verified'

      fill_in 'First name', with: 'Alex'
      click_button 'Save'

      visit admins_mechanics_path
      page.should have_css 'td', text: 'Alex Mechanic'
    end

    scenario 'fail' do
      visit admins_mechanics_path
      click_link 'Edit'
      page.should have_selector "h4", text: "Mechanic details"
      fill_in 'First name', with: ''
      click_button 'Save'
      page.should have_content "Please review the problems below:"
      page.should have_selector "#mechanic_business_location_attributes_address"
    end
  end

  it 'deletes a mechanic' do
    expect do
      visit edit_admins_mechanic_path(mechanic)
      click_link 'Delete'
    end.to change { Mechanic.count }.by -1

    page.should have_css '.alert', text: 'Mechanic successfully deleted.'
  end

  context 'edit images' do
    let(:image_path) { "#{Rails.root}/spec/features/fixtures/test_img.jpg" }

    scenario "uploading" do
      visit edit_admins_mechanic_path(mechanic)
      attach_file('mechanic_avatar', image_path)
      attach_file('mechanic_driver_license', image_path)
      attach_file('mechanic_abn', image_path)
      attach_file('mechanic_mechanic_license', image_path)
      expect { click_button 'Save' }.to change { all('img').length }.by(4)
      page.should have_content 'Mechanic successfully updated.'
      page.should have_selector 'img + div', text: 'test_img.jpg', count: 4
    end

    scenario "deleting", :js do
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

    scenario "uploading cancel", :js do
      visit edit_admins_mechanic_path(mechanic)
      attach_file('mechanic_mechanic_license', image_path)

      page.should have_selector '.file-input-name', text: 'test_img.jpg'
      expect do
        find('span.btn-change-image.btn-cancel-image-upload', text: '×').click
      end.to change { all('.file-input-name').length }.from(1).to(0)
      expect { click_button 'Save' }.not_to change { all('img').length }
    end
  end
end
