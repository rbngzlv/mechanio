shared_examples "navigation" do
  scenario 'check navigation' do
    visit send("#{role}_dashboard_path")
    within('.wrap > .container') { click_link 'My Profile' }
    current_url.should eql(send("#{role}_profile_url"))
    click_link 'Edit Profile'
    current_url.should eql(send("edit_#{role}_profile_url"))
    click_link 'cancel'
    current_url.should eql(send("#{role}_profile_url"))
  end
end
