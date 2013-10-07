shared_examples "description block" do
  specify 'comments count' do
    page.should have_selector 'span', text: "Reviews Left : #{object.reviews}"
  end

  specify 'default values when user is new' do
    page.should have_selector 'h4', text: object.full_name
    page.should have_content "Create some description"
  end
end
