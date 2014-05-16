require 'spec_helper'

describe 'Rate completed appointment' do

  let(:job)       { create :job, :completed, :with_service, mechanic: mechanic, user: user }
  let(:mechanic)  { create :mechanic }
  let(:user)      { create :user }

  before do
    login_user user
  end

  specify 'leave feedback', :js do
    visit users_appointment_path(job.id)

    page.should have_no_css 'p b', text: 'Published'

    within('.profile-border .rating') { page.should have_css '.empty-star', count: 5 }

    page.find('.feedback-submit')[:disabled].should be_true

    rating_categories = all('.rating.editable')
    within rating_categories[0] { find("span[data-value='2']").click }
    within rating_categories[1] { find("span[data-value='3']").click }
    within rating_categories[2] { find("span[data-value='1']").click }
    within rating_categories[3] { find("span[data-value='5']").click }
    within rating_categories[4] { find("span[data-value='4']").click }

    fill_in 'Tell us more', with: 'This mechanic done a great job!'
    choose 'Yes'

    click_on 'Save'

    page.should have_css '.modal h4', text: 'Thank you!'
    within('.modal') { click_on 'Close' }
    page.should have_no_css '.modal'

    within('.profile-border .rating') { page.should have_css '.full-star', count: 3 }

    page.should have_content 'YOUR FEEDBACK'

    within '.feedback' do
      rating_categories = all('.rating')
      within rating_categories[0] { page.should have_css '.full-star', count: 2 }
      within rating_categories[1] { page.should have_css '.full-star', count: 3 }
      within rating_categories[2] { page.should have_css '.full-star', count: 1 }
      within rating_categories[3] { page.should have_css '.full-star', count: 5 }
      within rating_categories[4] { page.should have_css '.full-star', count: 4 }

      page.should have_css 'p', text: 'This mechanic done a great job!'
      page.should_not have_button 'Save'
    end
  end
end
