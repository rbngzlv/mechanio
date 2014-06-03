require 'spec_helper'

describe 'Payout information' do

  let(:mechanic) { create :mechanic }
  let(:job)      { create :job, :with_service, :completed, :with_payout, mechanic: mechanic }

  before do
    login_mechanic mechanic
    visit mechanics_dashboard_path
  end

  specify 'top menu navigation', :js do
    within 'header.navbar' do
      click_on mechanic.full_name
      click_on 'My Payment'
    end

    page.should have_css '.nav-tabs li.active a', text: 'Payment'
    page.should have_css 'p', text: 'No payments'
    page.should have_css 'ul.nav-stacked li.active a', text: 'My Payment'
  end

  specify 'lists payments', :js do
    job

    visit edit_mechanics_payout_method_path

    page.should have_css 'tr', text: 'User Job Date Amount'
    page.should have_css 'td', text: '$100.00'
  end

  specify 'edit', :js do
    within 'ul.nav-stacked' do
      click_on 'My Payment'
    end

    within '.nav-tabs' do
      click_on 'Payout Information'
    end

    within '.panel-body' do
      click_on 'Edit'
    end

    fill_in 'Account name', with: 'Bank of Australia'
    fill_in 'Account number', with: '123456789'
    fill_in 'Bsb number', with: '123456'
    click_on 'Save'

    within '.nav-tabs' do
      click_on 'Payout Information'
    end

    page.should have_content 'Your payout information successfully updated.'
    page.should have_field 'Account name', with: 'Bank of Australia', disabled: true
    page.should have_field 'Account number', with: '123456789', disabled: true
    page.should have_field 'Bsb number', with: '123456', disabled: true
  end
end
