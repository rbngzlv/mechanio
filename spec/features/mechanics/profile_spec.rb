require 'spec_helper'

feature 'mechanic profile page' do
  let(:mechanic) { create :mechanic, super_mechanic: true, qualification_verified: true }

  subject { page }

  before { login_mechanic mechanic }

  include_examples("navigation") do
    let(:role) { 'mechanics' }
  end

  context 'check content' do
    before { visit mechanics_profile_path }

    scenario 'mechanic details' do
      should have_content mechanic.full_name
      find('img.avatar')['src'].should match /\/assets\/fallback\/thumb_default.jpg/

      should have_link '0 Reviews'
      should have_content mechanic.description
    end

    scenario 'check verified statuses work' do
      within '.verified-icons' do
        find('i:nth-child(1)')[:class].should eq 'icon-map-marker disabled'
        find('i:nth-child(2)')[:class].should eq 'icon-phone disabled'
        find('i:nth-child(3)')[:class].should eq ''
        find('i:nth-child(4)')[:class].should eq 'icon-thumbs-up disabled'
        find('i:nth-child(5)')[:class].should eq 'icon-book'
      end
    end
  end
end
