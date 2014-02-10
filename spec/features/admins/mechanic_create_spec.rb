require 'spec_helper'

feature 'adds a new mechanic', :js do
  let!(:state) { create :state, name: 'QLD' } # FIXME: states should be preloaded form seeds before suite
  let(:next_year)  { (Date.today.year + 1).to_s }
  let(:image_path) { "#{Rails.root}/spec/features/fixtures/test_img.jpg" }

  before { login_admin }

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
      attach_file 'mechanic_avatar',  image_path

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
      fill_in 'Business phone number', with: '0498765432'
      fill_in 'Business address', with: 'Sunset Blvd. 26'
      fill_in 'Suburb',           with: 'Sydney'
      select  'QLD',              from: 'State'
      fill_in 'Postcode',         with: '2000'
      attach_file 'mechanic_abn', image_path

      click_on 'Driver license'
      fill_in "Driver's License Number", with: '12345678'
      select  'QLD',        from: 'Registered state'
      select  next_year,    from: 'mechanic_license_expiry_1i'
      select  'September',  from: 'mechanic_license_expiry_2i'
      select  '1',          from: 'mechanic_license_expiry_3i'
      attach_file 'mechanic_driver_license', image_path

      click_on 'Motor license'
      fill_in 'Motor license number', with: 'MXF12388736423887364'
      select  'QLD',        from: 'Registered state'
      select  next_year,    from: 'mechanic_mechanic_license_expiry_1i'
      select  'September',  from: 'mechanic_mechanic_license_expiry_2i'
      select  '1',          from: 'mechanic_mechanic_license_expiry_3i'
      attach_file 'mechanic_mechanic_license', image_path

      click_on 'Badges'
      check 'Phone verified'

      click_button 'Save'

    end.to change { Mechanic.count }.by 1

    page.should have_css '.alert', text: 'Mechanic successfully created.'

    page.should have_field  'First name', with: 'First'
    page.should have_field  'Last name',  with: 'Last'
    page.should have_field  'Email',      with: 'mechanic@host.com'
    page.should have_field  'mechanic_dob_1i', with:     '1975'
    page.should have_select 'mechanic_dob_2i', selected: 'October'
    page.should have_field  'mechanic_dob_3i', with:     '1'
    page.should have_field  'Personal description', with: 'Something about me'
    page.should have_field  'Years as mechanic',    with: '3'
    page.should have_selector 'img + div', text: 'test_img.jpg'

    click_on 'Contact details'
    page.should have_field  'Mobile number',  with: '0410123456'
    page.should have_field  'Street Address', with: 'Seashell avenue, 25'
    page.should have_field  'Suburb',         with: 'Somewhere'
    page.should have_select 'mechanic_location_attributes_state_id', selected: 'QLD'
    page.should have_field  'Postcode',       with: 'AX12345'

    click_on 'Business details'
    page.should have_field  'Business name', with: 'My company'
    page.should have_field  'ABN number',    with: '12345678900'
    page.should have_field  'mechanic_abn_expiry_1i', with: next_year
    page.should have_select 'mechanic_abn_expiry_2i', selected: 'October'
    page.should have_field  'mechanic_abn_expiry_3i', with: '1'
    page.should have_field  'Business website',      with: 'http://my-company.com'
    page.should have_field  'Business email',        with: 'email@company.com'
    page.should have_field  'Business phone number', with: '0498765432'
    page.should have_field  'Business address',      with: 'Sunset Blvd. 26'
    page.should have_field  'Suburb',                with: 'Sydney'
    page.should have_select 'mechanic_business_location_attributes_state_id', selected: 'QLD'
    page.should have_field  'Postcode',              with: '2000'
    page.should have_selector 'img + div', text: 'test_img.jpg'

    click_on 'Driver license'
    page.should have_field  "Driver's License Number",             with: '12345678'
    page.should have_select 'mechanic_license_state_id',  selected: 'QLD'
    page.should have_field  'mechanic_license_expiry_1i', with: next_year
    page.should have_select 'mechanic_license_expiry_2i', selected: 'September'
    page.should have_field  'mechanic_license_expiry_3i', with: '1'
    page.should have_selector 'img + div', text: 'test_img.jpg'

    click_on 'Motor license'
    page.should have_field  'Motor license number',                with: 'MXF12388736423887364'
    page.should have_select 'mechanic_mechanic_license_state_id',  selected: 'QLD'
    page.should have_field  'mechanic_mechanic_license_expiry_1i', with: next_year
    page.should have_select 'mechanic_mechanic_license_expiry_2i', selected: 'September'
    page.should have_field  'mechanic_mechanic_license_expiry_3i', with: '1'
    page.should have_selector 'img + div', text: 'test_img.jpg'

    click_on 'Badges'
    page.should have_checked_field 'Phone verified'
    page.should have_unchecked_field 'Super mechanic'
    page.should have_unchecked_field 'Warranty covered'
    page.should have_unchecked_field 'Qualification verified'

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
