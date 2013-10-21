require 'spec_helper'

feature 'Admin mechanics management' do

  let!(:mechanic) { create :mechanic }

  before do
    login_admin
  end

  it 'lists available mechanics' do
    visit admin_mechanics_path

    page.should have_css 'td', text: mechanic.full_name
  end

  it 'shows mechanic details' do
    visit edit_admin_mechanic_path(mechanic)

    page.should have_css 'h4', text: 'Mechanic details'
    page.should have_field 'First name', with: mechanic.first_name
  end

  it 'adds a new mechanic' do
    mail_deliveries.clear
    visit admin_mechanics_path
    click_link 'Add mechanic'

    expect do
      fill_in 'First name', with: 'First'
      fill_in 'Last name', with: 'Last'
      fill_in 'Personal email', with: 'mechanic@host.com'
      select '1975',    from: 'mechanic_dob_1i'
      select 'October', from: 'mechanic_dob_2i'
      select '1',       from: 'mechanic_dob_3i'
      fill_in 'Personal description', with: 'Something about me'
      fill_in 'mechanic_location_attributes_address', with: 'Seashell avenue, 25'
      fill_in 'mechanic_location_attributes_suburb', with: 'Somewhere'
      select 'Queensland', from: 'mechanic_location_attributes_state_id'
      fill_in 'mechanic_location_attributes_postcode', with: 'AX12345'
      fill_in "Driver's license", with: 'MXF123887364'
      select 'Queensland', from: "mechanic_license_state_id"
      select '2015',      from: 'mechanic_license_expiry_1i'
      select 'September', from: 'mechanic_license_expiry_2i'
      select '1',         from: 'mechanic_license_expiry_3i'
      click_button 'Save'
    end.to change { Mechanic.count }.by 1

    page.should have_css '.alert', text: 'Mechanic succesfully created.'
    last_delivery.body.should include('mechanic@host.com')
    last_delivery.subject.should include('Thnx for ur registration')
  end

  scenario 'edits existing mechanic' do
    visit admin_mechanics_path
    page.should have_css 'td', text: 'Joe Mechanic'

    click_link 'Details'
    page.should have_content 'Business Details'
    check 'Phone verified'
    check 'Super mechanic'
    check 'Warranty covered'
    check 'Qualification verified'

    fill_in 'First name', with: 'Alex'
    click_button 'Save'

    visit admin_mechanics_path
    page.should have_css 'td', text: 'Alex Mechanic'
  end

  it 'deletes a mechanic' do
    expect do
      visit edit_admin_mechanic_path(mechanic)
      click_link 'Delete'
    end.to change { Mechanic.count }.by -1

    page.should have_css '.alert', text: 'Mechanic succesfully deleted.'
  end

  scenario "images uploading" do
    image_path = "#{Rails.root}/spec/features/fixtures/test_img.jpg"
    visit edit_admin_mechanic_path(mechanic)
    attach_file('mechanic_avatar', image_path)
    attach_file('mechanic_driver_license', image_path)
    attach_file('mechanic_abn', image_path)
    attach_file('mechanic_mechanic_license', image_path)
    expect { click_button 'Save' }.to change { all("img").length }.by(4)
    page.should have_content 'Mechanic succesfully updated.'
  end
end
