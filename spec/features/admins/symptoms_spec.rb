require 'spec_helper'

describe 'Symptoms management' do
  
  before do
    create :symptom_tree
    login_admin
  end

  it 'shows all symptoms' do
    visit admins_dashboard_path
    click_on 'Symptoms'
    page.should have_css 'h4', text: 'Manage symptoms'
    page.should have_css 'li', 'Looks like - What do you see?'
  end

  context 'on index page', :js, pending: 'Symptom editing should be updated to use new data structure' do
    before { visit admins_symptoms_path }

    it 'creates a new symptom' do
      click_on 'Add symptom'

      select 'Looks like', from: 'Parent category'
      fill_in 'Description', with: 'Vibration'
      click_on 'Save'

      page.should have_css '.alert-info', text: 'Symptom created successfully'
      page.should have_css 'td', text: 'Vibration'
    end

    it 'edits symptom' do
      within 'tr:nth-child(2)' do
        click_on 'Edit'
      end

      fill_in 'Description', with: 'Vibration'
      click_on 'Save'

      page.should have_css '.alert-info', text: 'Symptom updated successfully'
      page.should have_css 'td', text: 'Vibration'
    end

    it 'deletes a symptom' do
      within 'tr:nth-child(1)' do
        click_on 'Delete'
      end

      page.should have_css '.alert-info', text: 'Symptom(s) deleted successfully'
      page.should have_no_css 'th'
      page.should have_no_css 'td'
    end
  end
end
