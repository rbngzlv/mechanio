require 'spec_helper'

describe 'Ratings' do

  let(:rating)    { create :rating, user: user, mechanic: mechanic, job: job }
  let(:user)      { create :user }
  let(:job)       { create :job, :completed, :with_service }
  let(:mechanic)  { create :mechanic, first_name: 'Bob', last_name: 'Brown' }
  let(:another_mechanic) { create :mechanic, first_name: 'Joe', last_name: 'Smith' }

  before do
    login_admin
  end

  it 'lists ratings' do
    rating
    visit admins_dashboard_path

    within('.navbar') { click_on 'Feedback' }

    page.should have_css '.navbar-brand', text: 'Feedback'
    page.should have_css 'tr', text: 'Status Date From user To mechanic Job Score Recommend'
    page.should have_css 'td', text: 'Published'
    page.should have_css 'td', text: rating.average
  end

  it 'searches ratings by keywords' do
    rating
    create :rating, user: user, job: job, mechanic: another_mechanic

    visit admins_ratings_path

    page.should have_css 'tbody tr', count: 2

    fill_in 'query', with: 'smith'
    click_on 'Search'

    page.should have_css 'tbody tr', count: 1
    page.should have_css 'tbody td', text: 'Joe Smith'
  end

  it 'shows a message when no ratings exist' do
    visit admins_ratings_path

    page.should have_content 'No feedback found'
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

    click_on 'Feedback'

    page.should have_css 'td', 'Unpublished'
    page.should have_css 'td', '4.0'

    mechanic.reload.rating.should eq 0
  end
end
