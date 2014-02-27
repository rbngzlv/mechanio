require 'spec_helper'

feature 'Admin page - edit mechanic page - payout methods page' do
  let(:mechanic) { create :mechanic }
  let(:payout_method) { create :payout_method, mechanic: mechanic }

  before { login_admin }

  context 'add payout method' do
    it 'success' do
      visit edit_admins_mechanic_path(mechanic)
      click_on 'Payout'
      page.should have_css 'h4', text: 'This mechanic has no attached bank accounts'

      click_link 'Add Payout Method'
      page.should have_css 'h4', text: 'New Payout Method'

      fill_in 'Account Name', with: 'Account Name'
      fill_in 'Account Number', with: '1234567890'
      fill_in 'BSB Number', with: '123456'
      click_on 'Save'

      page.should have_css '.alert-info', text: 'Payout method successfully added.'
      page.should have_css 'tbody tr', text: 'Account Name 1234567890 123456 Edit Remove'
    end

    it 'fail' do
      visit new_admins_mechanic_payout_method_path(mechanic)
      click_on 'Save'
      page.should have_css '.alert-danger', text: 'Please review the problems below:'
    end

    it 'cancel' do
      visit new_admins_mechanic_payout_method_path(mechanic)
      click_link 'cancel'
      page.should have_css 'h4', text: 'This mechanic has no attached bank accounts'
    end
  end

  context 'payout exists' do
    before { payout_method }

    specify 'page should contain payout methods list' do
      another_payout_method = create :payout_method, mechanic: mechanic
      visit admins_mechanic_payout_methods_path(mechanic)
      page.should have_css 'tbody tr', text: "#{payout_method.account_name} #{payout_method.account_number} #{payout_method.bsb_number} Edit Remove"
      page.should have_css 'tbody tr', text: "#{another_payout_method.account_name} #{another_payout_method.account_number} #{another_payout_method.bsb_number} Edit Remove"
    end

    context 'manage' do
      before { visit admins_mechanic_payout_methods_path(mechanic) }

      context 'edit' do
        before { click_link 'Edit' }

        it 'success' do
          current_path.should be_eql edit_admins_mechanic_payout_method_path(mechanic, payout_method)
          page.should have_css 'h4', text: 'Edit Payout Method'
          fill_in 'Account Name', with: 'Another Account Name'
          click_on 'Save'
          page.should have_css '.alert-info', text: 'Payout method successfully updated.'
          page.should have_css 'tbody tr', text: "Another Account Name #{payout_method.account_number} #{payout_method.bsb_number} Edit Remove"
        end

        it 'fail' do
          fill_in 'Account Name', with: ''
          click_on 'Save'
          page.should have_css '.alert-danger', text: 'Please review the problems below:'
        end

        it 'cancel' do
          click_link 'cancel'
          page.should have_css 'h4', text: 'Payout'
        end
      end

      scenario 'remove' do
        click_link 'Remove'
        page.should have_css '.alert-info', text: 'Payout method successfully deleted.'
        page.should have_no_css 'tbody tr', text: payout_method.account_name
      end
    end
  end
end
