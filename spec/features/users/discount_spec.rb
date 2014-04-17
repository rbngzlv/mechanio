require 'spec_helper'

describe 'Discount', :js do
  let!(:discount) { create :discount, discount_value: 20, discount_type: 'percent' }
  let!(:user)     { create :user }
  let!(:mechanic) { create :mechanic, mechanic_regions: [create(:mechanic_region, postcode: job.location_postcode)] }
  let!(:job)      { create :job, :estimated, :with_service, user: user }
  let(:timeslot)  { Date.tomorrow.in_time_zone.advance(days: 3, hours: 9) }
  let(:book_mechanic_page)  { BookMechanicPage.new }
  let(:payment_page)        { PaymentPage.new }

  before do
    login_user user
    book_mechanic_page.visit_page(job)
    book_mechanic_page.select_mechanic(mechanic, timeslot)
  end

  it 'applies discount' do
    payment_page.apply_discount(discount.code)

    expect(payment_page).to have_discount(job.reload.discount_amount)
    expect(payment_page).to_not have_discount_form
    expect(page).to have_content 'Discount successfully applied'
  end

  it 'shows a message when discount failed' do
    payment_page.apply_discount('unexsiting')

    expect(payment_page).to have_discount_form
    expect(page).to have_content 'Discount code is invalid'
  end
end
