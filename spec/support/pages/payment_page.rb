class PaymentPage < PageObject

  def apply_discount(discount_code)
    within '.price-breakdown' do
      fill_in 'Enter promo code', with: discount_code
      click_button 'Apply'
    end
  end

  def has_discount?(discount_amount)
    within '.price-breakdown' do
      page.has_css? 'tr', text: "20% off discount #{number_to_currency discount_amount}"
    end
  end

  def has_discount_form?
    page.has_css? '.price-breakdown .promo-code'
  end
end
