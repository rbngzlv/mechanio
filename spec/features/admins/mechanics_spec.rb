require 'spec_helper'

feature 'Admin mechanics management' do

  let(:mechanic) { create :mechanic, mobile_number: '0410123456' }
  let(:next_year) { (Date.today.year + 1).to_s }
  let!(:state) { create :state, name: 'QLD' } # FIXME: states should be preloaded form seeds before suite

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
  end

  context 'adds a new mechanic', :js do
    scenario 'success' do
      mail_deliveries.clear
      visit admins_mechanics_path
      click_link 'Add mechanic'

      expect do
        fill_in 'First name', with: 'First'
        fill_in 'Last name',  with: 'Last'
        fill_in 'Email',      with: 'mechanic@host.com'
        select  '1975',       from: 'mechanic_dob_1i'
        select  'October',    from: 'mechanic_dob_2i'
        select  '1',          from: 'mechanic_dob_3i'
        fill_in 'Personal description', with: 'Something about me'
        fill_in 'Years as mechanic',    with: '3'

        click_on 'Contact details'
        fill_in 'Mobile number',  with: '0410123456'
        fill_in 'Street Address', with: 'Seashell avenue, 25'
        fill_in 'Suburb',         with: 'Somewhere'
        select  'QLD',            from: 'State'
        fill_in 'Postcode',       with: 'AX12345'

        click_on 'Business details'
        fill_in 'Business name', with: 'My company'
        fill_in 'ABN number',    with: '12345678900'
        select  next_year,       from: 'mechanic_abn_expiry_1i'
        select  'October',       from: 'mechanic_abn_expiry_2i'
        select  '1',             from: 'mechanic_abn_expiry_3i'
        fill_in 'Business website', with: 'http://my-company.com'
        fill_in 'Business email',   with: 'email@company.com'
        fill_in 'Business phone number', with: '01412345678'
        fill_in 'Business address', with: 'Sunset Blvd. 26'
        fill_in 'Suburb',           with: 'Sydney'
        select  'QLD',              from: 'State'
        fill_in 'Postcode',         with: '2000'

        click_on 'Driver license'
        fill_in 'License number', with: 'MXF12388736423887364'
        select  'QLD',        from: 'Registered state'
        select  next_year,    from: 'mechanic_license_expiry_1i'
        select  'September',  from: 'mechanic_license_expiry_2i'
        select  '1',          from: 'mechanic_license_expiry_3i'

        click_on 'Motor license'
        fill_in 'Motor license number', with: 'MXF12388736423887364'
        select  'QLD',        from: 'Registered state'
        select  next_year,    from: 'mechanic_mechanic_license_expiry_1i'
        select  'September',  from: 'mechanic_mechanic_license_expiry_2i'
        select  '1',          from: 'mechanic_mechanic_license_expiry_3i'

        click_on 'Badges'
        check 'Phone verified'

        click_button 'Save'

      end.to change { Mechanic.count }.by 1

      page.should have_css '.alert', text: 'Mechanic successfully created.'
      last_delivery.body.should include('mechanic@host.com')
      last_delivery.subject.should include('Welcome to Mechanio')
    end

    scenario 'fail' do
      visit admins_mechanics_path
      click_link 'Add mechanic'

      click_on 'Contact details'
      within '.mechanic_location_address' do
        page.should have_selector 'abbr', text: '*'
      end

      click_on 'Business details'
      within '.mechanic_business_location_address' do
        page.should have_no_selector 'abbr', text: '*'
      end
      click_button 'Save'

      page.should have_content 'Please review the problems below:'
    end
  end

  context 'edits existing mechanic' do
    before { mechanic }

    scenario 'success' do
      visit admins_mechanics_path
      page.should have_css 'td', text: 'Joe Mechanic'

      click_link 'Edit'
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

  it 'deletes a mechanic', :js do
    visit edit_admins_mechanic_path(mechanic)

    expect { click_link 'Delete' }.to change { Mechanic.count }.by -1
    page.should have_css '.alert', text: 'Mechanic successfully deleted.'
  end

  context 'edit images' do
    let(:image_path) { "#{Rails.root}/spec/features/fixtures/test_img.jpg" }

    scenario 'uploading' do
      visit edit_admins_mechanic_path(mechanic)
      attach_file('mechanic_avatar', image_path)

      click_on 'Business details'
      attach_file('mechanic_abn', image_path)

      click_on 'Driver license'
      attach_file('mechanic_driver_license', image_path)

      click_on 'Motor license'
      attach_file('mechanic_mechanic_license', image_path)

      expect { click_button 'Save' }.to change { all('img').length }.by(4)

      page.should have_content 'Mechanic successfully updated.'
      page.should have_selector 'img + div', text: 'test_img.jpg'
    end

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
      click_on 'Motor license'
      attach_file('mechanic_mechanic_license', image_path)

      page.should have_selector '.file-input-name', text: 'test_img.jpg'
      expect do
        find('span.btn-change-image.btn-cancel-image-upload', text: '×').click
      end.to change { all('.file-input-name').length }.from(1).to(0)
      expect { click_button 'Save' }.not_to change { all('img').length }
    end
  end
end
