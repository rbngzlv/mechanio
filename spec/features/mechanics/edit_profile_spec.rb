require 'spec_helper'

feature 'mechanic edit profile page' do
  let(:mechanic) { create :mechanic, first_name: 'Bob' }
  let(:next_year)  { (Date.today.year + 1).to_s }
  let(:image_path) { "#{Rails.root}/spec/fixtures/test_img.jpg" }

  # FIXME: states/regions should be preloaded form seeds before suite
  let!(:root_region)  { create :region, name: 'Root' }
  let!(:state)        { create :region, name: 'NSW', parent: root_region }
  let!(:sydney)       { create :sydney_suburb, parent: state }
  let!(:hill)         { create :hill_suburb, parent: state }

  subject { page }

  before do
    login_mechanic mechanic
    visit mechanics_profile_path
    click_link 'Edit Profile'
    should have_selector 'li.active a', text: 'Personal details'
  end

  context 'edit' do
    scenario 'success', :js do
      fill_in 'First name',     with: 'First'
      fill_in 'Last name',      with: 'Last'
      fill_in 'Personal email', with: 'new_email@host.com'
      select  '1975',           from: 'mechanic_dob_1i'
      select  'October',        from: 'mechanic_dob_2i'
      select  '1',              from: 'mechanic_dob_3i'
      fill_in 'Personal description', with: 'Something about me'
      attach_file 'mechanic_avatar',  image_path

      click_on 'Contact details'
      fill_in 'Mobile number',  with: '0410123456'
      fill_in 'Street Address', with: 'Seashell avenue, 25'
      autocomplete 'Suburb', 'the hil', 'The Hill, NSW 2300'

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
      autocomplete 'Suburb', 'the hill', 'The Hill, NSW 2300'
      attach_file 'mechanic_abn', image_path

      click_button 'Save'

      page.should have_css '.alert', text: 'Your profile successfully updated.'

      page.should have_field  'First name', with: 'First'
      page.should have_field  'Last name',  with: 'Last'
      page.should have_field  'Personal email',      with: 'new_email@host.com'
      page.should have_field  'mechanic_dob_1i', with:     '1975'
      page.should have_select 'mechanic_dob_2i', selected: 'October'
      page.should have_field  'mechanic_dob_3i', with:     '1'
      page.should have_field  'Personal description', with: 'Something about me'
      page.find('.mechanic_avatar img')['src'].should have_content 'test_img.jpg'

      click_on 'Contact details'
      page.should have_field  'Mobile number',  with: '0410123456'
      page.should have_field  'Street Address', with: 'Seashell avenue, 25'
      page.should have_field  'Suburb',         with: 'The Hill, NSW 2300'

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
      page.should have_field  'Suburb',                with: 'The Hill, NSW 2300'
      page.should have_selector 'img + div', text: 'test_img.jpg'
    end

    scenario 'fail' do
      fill_in 'mechanic_first_name', with: ''
      click_button 'Save'

      should have_content 'Please review the problems below'
      should have_selector '.has-error', text: "can't be blank"
    end

    scenario 'upload avatar' do
      attach_file('mechanic_avatar', "#{Rails.root}/spec/fixtures/test_img.jpg")
      click_button 'Save'

      should have_content 'Your profile successfully updated.'
      find('.mechanic_avatar img')['src'].should have_content mechanic.reload.avatar_url :thumb
    end
  end
end
