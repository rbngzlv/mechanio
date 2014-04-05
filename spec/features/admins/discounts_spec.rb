require 'spec_helper'

feature 'Discounts' do
  before { login_admin }

  context 'Discounts list' do
    scenario 'there are no discounts' do
      visit admins_dashboard_path

      within '.navbar' do
        click_on 'Discounts'
      end

      page.should have_css 'h4', text: 'Discounts'
      page.should have_content 'No discounts found'
    end

    scenario 'there are some discounts' do
      create :discount

      visit admins_discounts_path

      page.should have_css 'tr', text: 'Title Code Value Uses left Starts on Ends on'
      page.should have_css 'tr', text: '20% off 20OFF 20% unlimited - - Edit'
    end
  end

  scenario 'Create single discount' do
    visit admins_discounts_path

    click_on 'Create discount'

    fill_in 'Title', with: 'A discount'
    fill_in 'Code', with: '20OFF'
    fill_in 'Discount value', with: '20'
    select 'percent', from: 'Discount type'
    fill_in 'Uses', with: '2'
    select '2015', from: 'discount_starts_at_1i'
    select 'February', from: 'discount_starts_at_2i'
    select '1', from: 'discount_starts_at_3i'
    select '2015', from: 'discount_ends_at_1i'
    select 'March', from: 'discount_ends_at_2i'
    select '15', from: 'discount_ends_at_3i'
    click_on 'Save'

    page.should have_content 'Discount successfully created'
    page.should have_css 'tr', text: 'A discount 20OFF 20% 2 2015-02-01 2015-03-15'
  end

  context 'Edit discount' do
    before do
      create :discount, title: 'A discount'

      visit admins_discounts_path

      within 'table' do
        click_on 'Edit'
      end
    end

    scenario 'success' do
      fill_in 'Title', with: 'Edited discount'
      click_on 'Save'

      page.should have_content 'Discount successfully updated'
      page.should have_css 'td', text: 'Edited discount'
    end

    scenario 'failure' do
      fill_in 'Title', with: ''
      click_on 'Save'

      page.should have_content 'Please review the problems below:'
      page.should have_content "can't be blank"
    end
  end

  scenario 'Delete discount' do
    create :discount

    visit admins_discounts_path

    within 'table' do
      click_on 'Delete'
    end

    page.should have_content 'Discount successfully deleted'
    page.should have_content 'No discounts found'
  end
end
