require 'spec_helper'

describe 'Model catalog', pending: 'Fix make/model/variation js filtering' do

  let!(:mechanic) { create :mechanic }

  before do
    login_admin
  end

  it 'shows message when there are no models' do
    visit admins_model_variations_path

    page.should have_content 'No models found'
  end

  it 'searches models' do
    variation1 = create :model_variation
    variation2 = create :model_variation

    visit admins_model_variations_path
    page.should have_css 'tbody tr', count: 2

    select Make.first.name, from: 'model_variation_make_id'
    click_button 'Search'

    page.should have_css 'tbody tr', count: 1
  end
end
