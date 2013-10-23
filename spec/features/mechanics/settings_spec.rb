require 'spec_helper'

feature 'mechanic settings page' do
  include_examples("settings page") do
    let(:role) { 'mechanic' }
  end
end
