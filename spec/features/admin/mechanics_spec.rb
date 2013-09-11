require 'spec_helper'

describe 'Admin mechanics management' do

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
      fill_in 'Street address', with: 'Seashell avenue, 25'
      fill_in 'Suburb', with: 'Somewhere'
      select 'Queensland', from: 'State'
      fill_in 'Postcode', with: 'AX12345'
      fill_in "Driver's license", with: 'MXF123887364'
      select 'Queensland', from: "Registered state"
      select '2015',      from: 'mechanic_license_expiry_1i'
      select 'September', from: 'mechanic_license_expiry_2i'
      select '1',         from: 'mechanic_license_expiry_3i'
      click_button 'Save'
    end.to change { Mechanic.count }.by 1

    page.should have_css '.alert', text: 'Mechanic succesfully created.'
    mail_deliveries.last.tap do |letter|
      letter.body.should include('mechanic@host.com')
      letter.subject.should include('Thnx for ur registration')
    end
  end

  it 'edits existing mechanic' do
    visit admin_mechanics_path
    page.should have_css 'td', text: 'John Doe'

    click_link 'Details'

    fill_in 'First name', with: 'Alex'
    click_button 'Save'

    visit admin_mechanics_path
    page.should have_css 'td', text: 'Alex Doe'
  end

  it 'deletes a mechanic' do
    expect do
      visit edit_admin_mechanic_path(mechanic)
      click_link 'Delete'
    end.to change { Mechanic.count }.by -1

    page.should have_css '.alert', text: 'Mechanic succesfully deleted.'
  end
end
