require 'spec_helper'

feature 'user settings page' do
  include_examples("settings page") do
    let(:role) { 'user' }
  end
end
