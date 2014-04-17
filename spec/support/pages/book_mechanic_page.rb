class BookMechanicPage < PageObject

  def visit_page(job)
    visit edit_users_appointment_path(job)
  end

  def select_mechanic(mechanic, timeslot)
    within "#mechanic_#{mechanic.id}" do
      first('.fc-agenda-slots td.fc-widget-content').click
      find('#job_scheduled_at', visible: false)[:value].should == timeslot.to_s(:js)
      click_button 'Book Appointment'
    end
  end
end
