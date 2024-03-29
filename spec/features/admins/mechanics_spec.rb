require 'spec_helper'

feature 'Admin mechanics management' do

  let(:mechanic) { create :mechanic, mobile_number: '0410123456' }
  let(:job)      { create :job, :with_service, :assigned, mechanic: mechanic }
  let(:rating)   { create :rating, :with_user, mechanic: mechanic, job: job }

  before do
    login_admin
  end

  it 'lists available mechanics' do
    mechanic
    suspended_mechanic = create :mechanic, :suspended
    visit admins_mechanics_path

    date_joined = mechanic.created_at.to_s(:date_short)
    page.should have_css 'thead', text: 'Status Name Email Mobile Current Appts. Completed Jobs Total Earnings Feedback Score Date joined'
    page.should have_css 'tbody tr', text: "Active #{mechanic.full_name} #{mechanic.email} 0410123456 0 0 $0.00 0.0 #{date_joined} Edit"
    page.should have_css 'tbody td', text: "Suspended"
  end

  it 'searches mechanics by keywords' do
    mechanic
    another_mechanic = create :mechanic, first_name: 'Jimmy', last_name: 'Smith', email: 'jimmy@example.com', mobile_number: '0412345668'

    visit admins_mechanics_path

    page.should have_css 'tbody tr', count: 2

    fill_in 'query', with: 'Jim'
    click_on 'Search'

    signup_date = another_mechanic.created_at.to_s(:date_short)

    page.should have_css 'tbody tr', count: 1
    page.should have_css 'tr', text: "Active Jimmy Smith jimmy@example.com 0412345668 0 0 $0.00 0.0 #{signup_date} Edit"
  end

  it 'shows mechanic details' do
    visit edit_admins_mechanic_path(mechanic)

    page.should have_css 'h4', text: mechanic.full_name
    page.should have_field 'First name', with: mechanic.first_name

    within 'hr + .form-group' do
      page.should have_button 'Save'
    end
  end

  context 'edits existing mechanic' do
    before { mechanic }

    scenario 'success' do
      visit admins_mechanics_path
      page.should have_css 'td', text: 'Joe Mechanic'

      click_link 'Edit'
      page.should have_css '.nav-stacked li.active a', text: 'Edit Profile'

      fill_in 'First name', with: 'Alex'
      click_save
      page.should have_css '.alert-info', text: 'Mechanic successfully updated.'

      visit admins_mechanics_path
      page.should have_css 'td', text: 'Alex Mechanic'
    end

    scenario 'fail' do
      visit admins_mechanics_path
      click_link 'Edit'

      page.should have_selector 'h4', text: mechanic.full_name
      fill_in 'First name', with: ''
      click_save

      page.should have_selector '.form-group.has-error'
    end

    scenario 'lists and edits feedback', :js do
      rating
      visit admins_mechanics_path(mechanic)
      click_on 'Edit'
      within('.nav-stacked') { click_on 'Feedback' }

      page.should have_css '.nav-stacked li.active a', text: 'Feedback'
      page.should have_css 'tr', text: 'Date From user Job Score Recommend'
      page.should have_css 'td', text: 'No'

      click_on 'Edit'
      find('#rating_recommend_true').click
      click_on 'Save'

      page.should have_css '.nav-stacked li.active a', text: 'Feedback'
      page.should have_css 'td', text: 'Yes'
    end

    scenario 'edit payout information' do
      visit edit_admins_mechanic_path(mechanic)
      click_on 'Payments'

      fill_in 'Account name', with: 'Back on Australia'
      fill_in 'Account number', with: '1234567890'
      fill_in 'Bsb number', with: '123123'
      click_on 'Save'

      page.should have_content 'Payout information successfully updated.'
    end

    scenario 'edit regions', :js do
      root = create :region, name: 'Root'
      region1 = create :region, name: 'NSW', parent: root
      region2 = create :region, name: 'Sydney', parent: region1

      visit edit_admins_mechanic_path(mechanic)
      click_on 'Edit Regions'

      within '.tree' do
        all('input[type=checkbox]').each do |checkbox|
          checkbox.checked?.should be_false
        end

        first('input[type=checkbox]').set(true)

        page.should have_content 'Regions saved'

        all('input[type=checkbox]').each do |checkbox|
          checkbox.checked?.should be_true
        end
      end

      click_on 'Edit Regions'

      within '.tree' do
        all('input[type=checkbox]').each do |checkbox|
          checkbox.checked?.should be_true
        end
      end
    end
  end

  it 'deletes a mechanic', :js do
    visit edit_admins_mechanic_path(mechanic)

    expect {
      click_on 'More actions'
      click_on 'Delete mechanic'
    }.to change { Mechanic.count }.by -1
    page.should have_css '.alert', text: 'Mechanic successfully deleted.'
  end

  context 'suspend a mechanic' do
    before { visit edit_admins_mechanic_path(mechanic) }

    it 'success' do
      expect do
        click_on 'Suspend'
      end.to change { mechanic.reload.suspended_at }.from(nil)
      page.should have_selector '.alert-info', text: 'Mechanic successfully suspended.'
      page.should have_selector '.label-danger', text: "Suspended at #{mechanic.suspended_at.to_s(:date_short)}"
    end

    it 'fail' do
      Mechanic.any_instance.stub(:suspend).and_return(false)
      expect do
        click_on 'Suspend'
      end.not_to change { mechanic.reload.suspended_at }
      page.should have_selector '.label-success', text: 'Active'
      page.should have_selector '.alert-danger', text: 'Error updating mechanic.'
    end
  end

  context 'activate suspended mechanic' do
    let(:suspended_mechanic) { create :mechanic, :suspended }

    before { visit edit_admins_mechanic_path(suspended_mechanic) }

    it 'success' do
      expect do
        click_on 'Activate'
      end.to change { suspended_mechanic.reload.suspended_at }.to(nil)
      page.should have_selector '.alert-info', text: 'Mechanic successfully activated.'
      page.should have_selector '.label-success', text: 'Active'
    end

    it 'fails' do
      Mechanic.any_instance.stub(:activate).and_return(false)
      expect do
        click_on 'Activate'
      end.not_to change { suspended_mechanic.reload.suspended_at }.to(nil)
      page.should have_selector '.alert-danger', text: 'Error updating mechanic.'
      page.should have_selector '.label-danger', text: "Suspended at #{suspended_mechanic.suspended_at.to_s(:date_short)}"
    end
  end

  context 'edit images' do
    let(:image_path) { "#{Rails.root}/spec/fixtures/test_img.jpg" }

    scenario 'deleting', :js do
      mechanic.avatar = File.open(image_path)
      mechanic.save
      visit edit_admins_mechanic_path(mechanic)

      page.should have_selector '.file-input-name', text: 'test_img.jpg'
      expect do
        find('span.btn-change-image.btn-delete-image', text: '×').click
        sleep 0.1
      end.to change { mechanic.reload.avatar? }.from(true).to(false)
      page.should have_content 'Image successfully deleted.'
    end

    scenario 'uploading cancel', :js do
      visit edit_admins_mechanic_path(mechanic)
      click_on "Motor Mechanic's License"
      attach_file('mechanic_mechanic_license', image_path)

      page.should have_selector '.file-input-name', text: 'test_img.jpg'
      expect do
        find('span.btn-change-image.btn-cancel-image-upload', text: '×').click
      end.to change { all('.file-input-name').length }.from(1).to(0)
      expect { click_save }.not_to change { all('img').length }
    end
  end

  context 'jobs' do
    before do
      job
    end

    scenario 'lists mechanics jobs' do
      visit edit_admins_mechanic_path(mechanic)
      within '.nav-stacked' do
        click_on 'Jobs'
      end

      page.should have_css 'h4', text: mechanic.full_name
      page.should have_css 'tr', text: 'ID Status Job Requested by Cost'
      page.should have_css 'tr', text: "#{job.uid}"
    end
  end

  def click_save
    within 'hr + .form-group' do
      click_button 'Save'
    end
  end
end
