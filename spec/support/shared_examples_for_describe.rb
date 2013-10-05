shared_examples "describe" do
  specify 'comments count' do
    page.should have_selector 'span', text: "Reviews Left : #{subject.reviews}"
  end

  specify 'default values when user is new' do
    page.should have_selector 'h4', text: subject.full_name
    page.should have_content "Create some description"
  end
end
