require 'spec_helper'

describe 'Manage service plans' do

  let(:service_plan)          { create :service_plan, model_variation: model_variation }
  let(:default_service_plan)  { create :default_service_plan }
  let(:model)                 { create :model }
  let(:another_model)         { create :model, model_variations: [] }
  let(:model_variation)       { create :model_variation, make: model.make, model: model }
  let(:another_variation)     { create :model_variation, make: model.make, model: model }

  before do
    login_admin
  end

  context 'default plans' do

    it 'shows a message when there are no service plans' do
      visit default_admins_service_plans_path

      page.should have_content 'No service plans'
    end

    it 'shows service plans' do
      default_service_plan
      visit default_admins_service_plans_path

      page.should have_css 'td', text: default_service_plan.display_title
    end

    context 'add service plan' do
      before do
        visit default_admins_service_plans_path
        click_on 'Add service plan'
      end

      it 'periodic' do
        fill_in 'Kms travelled', with: '15000'
        fill_in 'Months', with: '8'
        fill_in 'Cost', with: '250'
        click_on 'Save'

        page.should have_css 'h4', text: 'Default service plans'
        page.should have_css '.alert-info', text: 'Service plan created successfully.'
        page.should have_css 'td', text: '15,000 kms / 8 months'
      end

      it 'custom' do
        fill_in 'Title', with: 'Minor/Interim'
        fill_in 'Cost', with: '250'
        click_on 'Save'

        page.should have_css 'h4', text: 'Default service plans'
        page.should have_css '.alert-info', text: 'Service plan created successfully.'
        page.should have_css 'td', text: 'Minor/Interim'
      end
    end

    it 'edit service plan' do
      default_service_plan
      visit default_admins_service_plans_path
      page.should have_css 'td', text: default_service_plan.display_title
      click_on 'Edit'

      fill_in 'Kms travelled', with: '20000'
      click_on 'Save'

      page.should have_css 'h4', text: 'Default service plans'
      page.should have_css '.alert-info', text: 'Service plan updated successfully.'
      page.should have_css 'td', text: '20,000 kms / 6 months'
    end

    specify 'delete service plan' do
      visit edit_admins_service_plan_path(default_service_plan)
      click_on 'Delete'
      current_path.should be_eql default_admins_service_plans_path
      page.should have_css'.alert.alert-info', text: 'Service plan deleted successfully'
    end

    specify 'delete service plan from index' do
      default_service_plan
      visit default_admins_service_plans_path
      click_link 'Delete'
      current_path.should be_eql default_admins_service_plans_path
      page.should have_css '.alert.alert-info', text: 'Service plan deleted successfully'
    end
  end

  context 'plans by car model', :js do

    context 'no service plans' do
      before { another_variation }

      it 'shows a message' do
        visit by_model_admins_service_plans_path
        select_model_variation(another_variation)

        page.should have_content 'No service plans'
      end
    end

    context 'no model variations' do
      before do
        model_variation
        another_model
      end

      it 'shows a message' do
        visit by_model_admins_service_plans_path

        select_another_model
        page.should have_css '.alert-danger', text: 'No model variations found'

        select_model_variation
        page.should_not have_css '.alert-danger'
      end
    end

    context 'add service plan' do
      before do
        model_variation
        visit by_model_admins_service_plans_path
        select_model_variation
        click_on 'Add service plan'
      end

      it 'periodic' do
        fill_in 'Kms travelled', with: '15000'
        fill_in 'Months', with: '8'
        fill_in 'Cost', with: '250'
        click_on 'Save'

        page.should have_css '.alert-info', text: 'Service plan created successfully.'
        page.should have_css 'td', text: '15,000 kms / 8 months'
        verify_selected_model
      end

      it 'custom' do
        fill_in 'Title', with: 'Minor/Interim'
        fill_in 'Cost', with: '250'
        click_on 'Save'

        page.should have_css '.alert-info', text: 'Service plan created successfully.'
        page.should have_css 'td', text: 'Minor/Interim'
        verify_selected_model
      end
    end

    context 'existing service plan' do
      before do
        service_plan
        visit by_model_admins_service_plans_path
        select_model_variation
      end

      it 'edits service plan' do
        page.should have_css 'td', text: service_plan.display_title
        click_on 'Edit'

        fill_in 'Kms travelled', with: '20000'
        click_on 'Save'

        page.should have_css '.alert-info', text: 'Service plan updated successfully.'
        page.should have_css 'td', text: '20,000 kms / 6 months'
        verify_selected_model
      end

      specify 'delete service plan' do
        click_on 'Edit'
        click_on 'Delete'
        page.should have_css '.alert.alert-info', text: 'Service plan deleted successfully'
        verify_selected_model
      end

      specify 'delete service plan from index' do
        click_link 'Delete'
        page.should have_css '.alert.alert-info', text: 'Service plan deleted successfully'
        verify_selected_model
      end
    end

    def select_another_model
      select model_variation.from_year, from: 'filter_year'
      select another_model.make.name, from: 'filter_make_id'
      select another_model.name, from: 'filter_model_id'
    end

    def select_model_variation(variation = nil)
      variation ||= model_variation
      select variation.from_year, from: 'filter_year'
      select variation.make.name, from: 'filter_make_id'
      select variation.model.name, from: 'filter_model_id'
      select variation.detailed_title, from: 'filter_model_variation_id'
    end

    def verify_selected_model
      page.should have_css 'th', text: "Service plans for #{model_variation.title_with_year}"
      page.should have_select 'filter_year', selected: model_variation.from_year.to_s
      page.should have_select 'filter_make_id', selected: model_variation.make.name
      page.should have_select 'filter_model_id', selected: model_variation.model.name
      page.should have_select 'filter_model_variation_id', selected: model_variation.detailed_title
    end
  end
end
