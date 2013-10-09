require 'spec_helper'

describe 'Manage service periods', pending: 'Fix make/model js filtering' do

  let(:service_plan)          { create :service_plan, model_variation: model_variation }
  let(:default_service_plan)  { create :default_service_plan }
  let(:model)                 { create :model }
  let(:model_variation)       { create :model_variation, make: model.make, model: model }

  before do
    login_admin
  end

  context 'default service plans' do

    it 'shows a message when there are no service plans' do
      visit default_admin_service_plans_path

      page.should have_content 'No service plans'
    end

    it 'shows service plans' do
      default_service_plan
      visit default_admin_service_plans_path

      page.should have_css 'td', text: default_service_plan.display_title
    end

    context 'add service plan' do
      before do
        visit default_admin_service_plans_path
        click_on 'Add service plan'
      end

      it 'periodic' do
        fill_in 'Kms travelled', with: '15000'
        fill_in 'Months', with: '8'
        fill_in 'Cost', with: '250'
        click_on 'Save'

        page.should have_css 'h4', text: 'Default service plans'
        page.should have_css '.alert-info', text: 'Service plan created succesfully.'
        page.should have_css 'td', text: '15,000 kms / 8 months'
      end

      it 'custom' do
        fill_in 'Title', with: 'Minor/Interim'
        fill_in 'Cost', with: '250'
        click_on 'Save'

        page.should have_css 'h4', text: 'Default service plans'
        page.should have_css '.alert-info', text: 'Service plan created succesfully.'
        page.should have_css 'td', text: 'Minor/Interim'
      end
    end

    it 'edit service plan' do
      default_service_plan
      visit default_admin_service_plans_path
      page.should have_css 'td', text: '10,000 kms / 6 months'
      click_on 'Edit'

      fill_in 'Kms travelled', with: '20000'
      click_on 'Save'

      page.should have_css 'h4', text: 'Default service plans'
      page.should have_css '.alert-info', text: 'Service plan updated succesfully.'
      page.should have_css 'td', text: '20,000 kms / 6 months'
    end
  end

  context 'car model service plans', :js do

    it 'shows a message when there are no service plans' do
      model_variation
      visit by_model_admin_service_plans_path
      select_model_variation

      page.should have_content 'No service plans'
    end

    it 'shows service plans' do
      service_plan
      visit by_model_admin_service_plans_path
      select_model_variation

      page.should have_css 'td', text: service_plan.display_title
    end

    context 'add service plan' do
      before do
        model_variation
        visit by_model_admin_service_plans_path
        select_model_variation
        click_on 'Add service plan'
      end
        
      it 'periodic' do
        fill_in 'Kms travelled', with: '15000'
        fill_in 'Months', with: '8'
        fill_in 'Cost', with: '250'
        click_on 'Save'

        page.should have_css 'th', text: "Service plans for #{model_variation.full_title}"
        page.should have_css '.alert-info', text: 'Service plan created succesfully.'
        page.should have_css 'td', text: '15,000 kms / 8 months'
      end

      it 'custom' do
        fill_in 'Title', with: 'Minor/Interim'
        fill_in 'Cost', with: '250'
        click_on 'Save'

        page.should have_css 'th', text: "Service plans for #{model_variation.full_title}"
        page.should have_css '.alert-info', text: 'Service plan created succesfully.'
        page.should have_css 'td', text: 'Minor/Interim'
      end
    end

    it 'edit service plan' do
      service_plan
      visit by_model_admin_service_plans_path
      select_model_variation
      page.should have_css 'td', text: '10,000 kms / 6 months'
      click_on 'Edit'

      fill_in 'Kms travelled', with: '20000'
      click_on 'Save'

      page.should have_css 'th', text: "Service plans for #{model_variation.full_title}"
      page.should have_css '.alert-info', text: 'Service plan updated succesfully.'
      page.should have_css 'td', text: '20,000 kms / 6 months'
    end

    def select_model_variation
      select model_variation.make.name, from: 'service_plan_make_id'
      select model_variation.model.name, from: 'service_plan_model_id'
      select model_variation.display_title, from: 'service_plan_model_variation_id'
      click_on 'Select'
    end
  end
end
