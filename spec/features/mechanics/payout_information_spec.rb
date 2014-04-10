require 'spec_helper'

describe 'Payout information' do

  let(:mechanic) { create :mechanic }

  before do
    login_mechanic mechanic
    visit mechanics_dashboard_path
  end

  specify 'top menu navigation', :js do
    within 'header.navbar' do
      click_on mechanic.full_name
      click_on 'Payout Information'
    end

    page.should have_css 'h4', text: 'Payout Information'
    page.should have_css 'ul.nav-stacked li.active a', text: 'Payout Information'
  end

  specify 'edit', :js do
    within 'ul.nav-stacked' do
      click_on 'Payout Information'
    end

    within '.panel-heading' do
      click_on 'Edit'
    end

    fill_in 'Account name', with: 'Bank of Australia'
    fill_in 'Account number', with: '123456789'
    fill_in 'Bsb number', with: '123456'
    click_on 'Save'

    page.should have_content 'Your payout information successfully updated.'
    page.should have_field 'Account name', with: 'Bank of Australia', disabled: true
    page.should have_field 'Account number', with: '123456789', disabled: true
    page.should have_field 'Bsb number', with: '123456', disabled: true
  end
end
