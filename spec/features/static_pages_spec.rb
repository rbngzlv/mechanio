require 'spec_helper'

describe 'Static Pages' do
  subject { page }

  before { visit root_path }

  describe 'Homepage' do
    it 'shows homepage' do
      should have_link 'Sign up'
      should have_link 'Login'
      should have_content 'Book professional mobile mechanics to service or repair your car at your convenience'
    end

    it 'has feature to prefill email for signup page' do
      fill_in 'youremail@address.com', with: 'prefill_test@example.com'
      click_button 'SIGN UP'
      find_field('user_email').value.should eq 'prefill_test@example.com'
    end

    it 'has footer with static pages navigation' do
      within 'footer' do
        should have_link 'About Us', href: page_path(:about_us)
        should have_link 'Frequently Asked Questions', href: page_path(:faq)
        should have_link 'Terms Of Use', href: page_path(:terms_of_use)
        should have_link 'Privacy Policy', href: page_path(:privacy_policy)
        should have_link 'Contact Us', href: page_path(:contact_us)
      end
    end
  end

  specify 'About Us' do
    go_to 'About Us'

    should have_selector 'h3', text: "About us"
  end

  specify 'Frequently Asked Questions' do
    go_to 'Frequently Asked Questions'

    should have_selector 'h4.hx-default', text: "Frequently Asked Questions"
  end

  specify 'Terms Of Use' do
    go_to 'Terms Of Use'

    should have_selector 'li.active', text: "Terms of use"
    should have_selector 'h5', text: "CUSTOMER TERMS AND CONDITIONS"
  end

  specify 'Privacy Policy' do
    go_to 'Privacy Policy'

    should have_selector 'li.active', text: "Privacy policy"
    should have_selector 'h5', text: "Mechanio Privacy Policy"
  end

  specify 'Contact Us' do
    go_to 'Contact Us'

    should have_selector 'h3', text: "Contact Us"
  end

  def go_to(page_name)
    within('footer') { click_link page_name }
  end
end
