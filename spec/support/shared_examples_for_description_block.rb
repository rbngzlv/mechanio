shared_examples "description block" do
  specify 'comments count' do
    page.should have_selector 'span', text: reviews_count
  end

  specify 'default values when user is new' do
    page.should have_selector 'h4', text: full_name
    page.should have_content "Add some information about yourself"
  end
end
