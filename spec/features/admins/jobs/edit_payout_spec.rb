require 'spec_helper'

feature 'Edit payout', :js do

  let(:job)           { create :job, :with_service, :charged, mechanic: mechanic }
  let(:payout_method) { create :payout_method, account_name: 'Some bank', account_number: '99988881', bsb_number: '987654' }
  let(:mechanic)      { create :mechanic, payout_method: payout_method }
  let(:receipt_path)  { "#{Rails.root}/spec/fixtures/test_img.jpg" }

  before do
    login_admin
  end

  scenario 'validation fails' do
    visit_payout

    click_on 'Save payout'

    page.should have_css '.form-group.has-error'
    page.should have_css '.nav-tabs .active a', text: 'Payout'
  end

  scenario 'creates a payout', :js do
    visit_payout

    fill_in 'Account name',   with: 'Bank of Australia'
    fill_in 'Bsb number',     with: '123456'
    fill_in 'Account number', with: '1234567890'
    fill_in 'Amount',         with: '100,50'
    fill_in 'Receipt number', with: 'ASDSA11231'
    attach_file 'Receipt',    receipt_path
    click_on 'Save payout'

    page.should have_content 'Payout successfully saved'

    within '.nav-tabs' do
      click_on 'Payout'
    end

    page.should have_link 'test_img.jpg'
  end

  scenario 'updates a payout' do
    job.payout = create :payout, mechanic: mechanic
    job.save

    visit_payout

    click_on 'Edit'
    click_on 'Save payout'

    page.should have_content 'Payout successfully saved'
  end

  scenario 'payout is prefilled with mechanics bank details' do
    visit_payout

    page.should have_field 'Account name',    with: 'Some bank'
    page.should have_field 'Bsb number',      with: '987654'
    page.should have_field 'Account number',  with: '99988881'
  end

  def visit_payout
    visit edit_admins_job_path(job)

    within '.nav-tabs' do
      click_on 'Payout'
    end
  end
end