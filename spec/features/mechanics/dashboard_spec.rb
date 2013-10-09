require 'spec_helper'

feature 'dashboard page' do
  let(:mechanic) { create :mechanic, description: nil }

  subject { page }

  before do
    login_mechanic mechanic
    visit mechanics_dashboard_path
  end

  context 'should have dynamic content' do
    include_examples("description block") do
      let(:reviews_count) { "#{mechanic.reviews} Reviews" }
      let(:profile) { mechanic }
    end
  end
end
