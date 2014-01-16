require 'spec_helper'

feature 'Admin mechanics management' do

  let!(:mechanic) { create :mechanic }

  before do
    login_admin
  end

  it 'lists available mechanics' do
    visit admins_mechanics_path

    page.should have_css 'td', text: mechanic.full_name
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

      page.should have_css '.alert', text: 'Mechanic succesfully created.'
      last_delivery.body.should include('mechanic@host.com')
      last_delivery.subject.should include('Welcome to Mechanio')
    end

    scenario 'fail' do
      visit admins_mechanics_path
      click_link 'Add mechanic'
      current_path.should be_eql new_admins_mechanic_path
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
      current_path.should be_eql edit_admins_mechanic_path(mechanic)
      page.should have_no_selector "legend", text: "Mechanic Details"
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

    page.should have_css '.alert', text: 'Mechanic succesfully deleted.'
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
      page.should have_content 'Mechanic succesfully updated.'
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
      end.to change { within('div.mechanic_avatar') { all('img').length } }.from(1).to(0)
      page.should have_content 'Image succesfully delted.'
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
