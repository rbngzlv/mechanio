require 'spec_helper'

feature 'Admin mechanics management' do

  let!(:mechanic) { create :mechanic }

  before do
    login_admin
  end

  it 'lists available mechanics' do
    # TODO: вынести это в лет?
    mechanic.mobile_number = '0410123456'
    # TODO: this string need for update phone number
    mechanic.save
    create(:job_with_service, :completed, mechanic: mechanic)
    create(:job_with_service, :confirmed, mechanic: mechanic)
    create(:job_with_service, :assigned, mechanic: mechanic)
    visit admins_mechanics_path

    page.should have_css 'td', text: mechanic.full_name
# 2) Missing Table headers:
# 2.1) Completed Jobs: (able sort through most – least) amount of jobs completed in columns
# 2.2) Total Earnings (can sort through highest earning – lowest earning): $ amount in columns
# 2.3) Average Feedback Score: (can sort through highest score – lowest score) Score between 0 to 5 in columns
# 2.4) Mobile Number: Mechanic Mobile number displayed in columns
    page.should have_css 'th:nth-child(2)', text: 'Completed Jobs'
    page.should have_css 'th:nth-child(3)', text: 'Total Earnings'
    page.should have_css 'th:nth-child(4)', text: 'Average Feedback Score'
    page.should have_css 'th:nth-child(5)', text: 'Mobile Number'
    within 'tbody' do
      # также здесь нужно разобраться - какие именно работы считаются комплитед(оплаченные с фидбеком/без, не оплаченные?)
      # TODO: я не могу проверить первый пункт так как не известно, что в данном случае является закрытм таском...
      page.should have_css 'tr:nth-child(1) td:nth-child(2)', text: '1' # я должен быть уверенным, что здесь нужное мне значение(например две законченных работы)
      page.should have_css 'tr:nth-child(1) td:nth-child(3)', text: mechanic.earnings # такого метода нет, он должен верно подсчитывать кол-во денег, соответственно на него нужен "тест вперед"
      # может покачто earnings тоже заткнуть фейковым методом?
      page.should have_css 'tr:nth-child(1) td:nth-child(4)', text: '2' # есть фейковый метод mechanic.rating, его нужно превратить в реальный и добавить к нему тесты(а лучше его за БДДшить)
      page.should have_css 'tr:nth-child(1) td:nth-child(5)', text: '0410123456' # я должен быть уверен в значениях которые должны тобораэаться, т.е. вместо образения к свойству механика
      # здесь должен быть номер телефона, который у механика(на самом деле тоже самое косается и всех остальных пунктов), т.е. получается, что сейчас я накидал способы получения значений
      # для данных полей, а в реальном тесте должны быть статические строки
    end
  end

  it 'shows mechanic details' do
    visit edit_admins_mechanic_path(mechanic)

    page.should have_css 'h4', text: 'Mechanic details'
    page.should have_field 'First name', with: mechanic.first_name
  end

  it 'adds a new mechanic' do
    mail_deliveries.clear
    visit admins_mechanics_path
    click_link 'Add mechanic'

    expect do
      fill_in 'First name', with: 'First'
      fill_in 'Last name', with: 'Last'
      fill_in 'Personal email', with: 'mechanic@host.com'
      select '1975',    from: 'mechanic_dob_1i'
      select 'October', from: 'mechanic_dob_2i'
      select '1',       from: 'mechanic_dob_3i'
      fill_in 'Personal description', with: 'Something about me'
      fill_in 'mechanic_location_attributes_address', with: 'Seashell avenue, 25'
      fill_in 'mechanic_location_attributes_suburb', with: 'Somewhere'
      select 'Queensland', from: 'mechanic_location_attributes_state_id'
      fill_in 'mechanic_location_attributes_postcode', with: 'AX12345'
      fill_in "Driver's license", with: 'MXF123887364'
      select 'Queensland', from: "mechanic_license_state_id"
      select '2015',      from: 'mechanic_license_expiry_1i'
      select 'September', from: 'mechanic_license_expiry_2i'
      select '1',         from: 'mechanic_license_expiry_3i'
      click_button 'Save'
    end.to change { Mechanic.count }.by 1

    page.should have_css '.alert', text: 'Mechanic succesfully created.'
    last_delivery.body.should include('mechanic@host.com')
    last_delivery.subject.should include('Welcome to Mechanio')
  end

  scenario 'edits existing mechanic' do
    visit admins_mechanics_path
    page.should have_css 'td', text: 'Joe Mechanic'

    click_link 'Edit'
    page.should have_content 'Business Details'
    check 'Phone verified'
    check 'Super mechanic'
    check 'Warranty covered'
    check 'Qualification verified'

    fill_in 'First name', with: 'Alex'
    click_button 'Save'

    visit admins_mechanics_path
    page.should have_css 'td', text: 'Alex Mechanic'
  end

  it 'deletes a mechanic' do
    expect do
      visit edit_admins_mechanic_path(mechanic)
      click_link 'Delete'
    end.to change { Mechanic.count }.by -1

    page.should have_css '.alert', text: 'Mechanic succesfully deleted.'
  end

  scenario "images uploading" do
    image_path = "#{Rails.root}/spec/features/fixtures/test_img.jpg"
    visit edit_admins_mechanic_path(mechanic)
    attach_file('mechanic_avatar', image_path)
    attach_file('mechanic_driver_license', image_path)
    attach_file('mechanic_abn', image_path)
    attach_file('mechanic_mechanic_license', image_path)
    expect { click_button 'Save' }.to change { all("img").length }.by(4)
    page.should have_content 'Mechanic succesfully updated.'
  end
end
