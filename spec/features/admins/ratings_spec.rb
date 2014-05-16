require 'spec_helper'

describe 'Ratings' do

  let(:rating)    { create :rating, user: user, mechanic: mechanic, job: job }
  let(:user)      { create :user }
  let(:mechanic)  { create :mechanic }
  let(:job)       { create :job, :completed, :with_service }

  before do
    login_admin
  end

  it 'lists ratings' do
    rating
    visit admins_dashboard_path

    within('.navbar') { click_on 'Feedback' }

    page.should have_css 'h4', text: 'Feedback'
    page.should have_css 'tr', text: 'Status Date From user To mechanic Job Score Recommend'
    page.should have_css 'td', text: 'Published'
    page.should have_css 'td', text: rating.average
  end

  it 'shows a message when no ratings exist' do
    visit admins_ratings_path

    page.should have_content 'No feedback left'
  end

  it 'edits rating', :js do
    rating
    mechanic.update_rating
    mechanic.rating.should eq 3.4

    visit admins_ratings_path

    page.should have_css 'td', '3.4'

    click_on 'Edit'

    page.should have_css 'h4', text: 'Edit rating'
    first('.rating.editable').first('span').click
    find('#rating_published_false').click
    click_on 'Save'

    page.should have_content 'Rating updated successfuly'
    page.should have_css 'td', 'Unpublished'
    page.should have_css 'td', '4.0'

    mechanic.reload.rating.should eq 0
  end
end
