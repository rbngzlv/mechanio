require 'spec_helper'

feature 'Admin page - edit mechanic page - payout methods' do
  let(:mechanic) { create :mechanic }
  # TODO: check is always should be create?
  let(:payout_method) { create :payout_method, mechanic: mechanic }

  before { login_admin }

  specify 'page should contain payout methods list' do
    # TODO: in general in integration tests max information should be from interface. That I think I should use creation from UI instead factories
    payout_method
    another_payout_method = create :payout_method, mechanic: mechanic
    visit edit_admins_mechanic_path(mechanic)

    # TODO: what order should be here? how many methods could has mechanic?
    page.should have_css 'tbody tr', text: "#{payout_method.account_name} #{payout_method.account_number} #{payout_method.bsb_number} Edit Remove"
    page.should have_css 'tbody tr', text: "#{another_payout_method.account_name} #{another_payout_method.account_number} #{another_payout_method.bsb_number} Edit Remove"

    # TODO: I can delete further string, because it repeated into scenario which click this link and add payout method after clicking...
    page.should have_link 'Add Payout Method', href: new_admins_mechanic_payout_method_path(mechanic)
  end

  # TODO: edit and new page should have link "Back to Mechanic" or "cancel"

  context 'add payout method' do
    before do
      visit edit_admins_mechanic_path(mechanic)
      click_link 'Add Payout Method'
    end

    it 'success' do
      page.should have_css 'h4', text: 'New Payout Method'

      fill_in 'Account Name', with: 'Account Name'
      fill_in 'Account Number', with: '1234567890'
      fill_in 'BSB Number', with: '123456'
      click_on 'Save'

      page.should have_css '.alert-info', text: 'Payout method successfully added.'
      # TODO: is it should be redirected to edit page(now it should be redirected to "index")?
      page.should have_css 'tbody tr', text: 'Account Name 1234567890 123456 Edit Remove'
    end

    it 'fail' do
      click_on 'Save'
      page.should have_css '.alert-danger', text: 'Please review the problems below:'
    end

    it 'cancel'
  end

  context 'edit payout method' do
    before do
      payout_method
      visit edit_admins_mechanic_path(mechanic)
      # TODO: add test to test path(is correct payout_method we edit?)
      click_link 'Edit'
    end

    it 'success' do
      page.should have_css 'h4', text: 'Edit Payout Method'
      fill_in 'Account Name', with: 'Another Account Name'
      click_on 'Save'
      page.should have_css '.alert-info', text: 'Payout method successfully updated.'
      # TODO: is it should be redirected to edit page(now it should be redirected to "index")?
      page.should have_css 'tbody tr', text: "Another Account Name #{payout_method.account_number} #{payout_method.bsb_number} Edit Remove"
    end

    it 'fail' do
      fill_in 'Account Name', with: ''
      click_on 'Save'
      page.should have_css '.alert-danger', text: 'Please review the problems below:'
    end

    it 'cancel'
  end

  scenario 'remove payout method' do
    payout_method
    visit edit_admins_mechanic_path(mechanic)
    click_link 'Remove'
    page.should have_css '.alert-info', text: 'Payout method successfully deleted.'
    page.should have_no_css 'tbody tr', text: payout_method.account_name
  end
end
