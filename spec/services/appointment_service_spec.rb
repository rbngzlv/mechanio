describe AppointmentService do

  let!(:job) { create :job, :with_service, :with_credit_card, :estimated }
  let(:mechanic) { create :mechanic }
  let(:tomorrow) { Date.tomorrow + 10.hours }
  let(:appointment) { initaltize_appotinment(tomorrow, mechanic.id) }

  describe '#initialize' do
    it 'raises error when invalid params passed' do
      expect {
        initaltize_appotinment(nil, nil)
      }.to raise_error
    end

    it 'raises error when mechanic is not found' do
      expect {
        initaltize_appotinment(tomorrow, 1234)
      }.to raise_error
    end
  end

  describe 'validations' do
    it 'is valid when scheduled_at is tomorrow or later' do
      appointment = initaltize_appotinment(Date.today, mechanic.id)
      appointment.should_not be_valid

      appointment.scheduled_at = tomorrow
      appointment.should be_valid
    end

    it 'is valid when mechanic is available' do
      appointment.should be_valid
    end

    it 'is invalid when mechanic is unavailable' do
      mechanic.events.create(
        date_start: tomorrow,
        time_start: tomorrow,
        time_end: tomorrow + 2.hours,
        job: job
      )
      appointment.should_not be_valid
    end
  end

  it 'reserves the appointment with mechanic' do
    reset_mail_deliveries

    appointment.confirm.should be_true

    job.scheduled_at.should     == tomorrow
    job.event.time_start.should == tomorrow
    job.event.should  == mechanic.events.last
    job.status.should == 'assigned'
    job.assigned_at.should_not be_nil
    mail_deliveries.count.should == 3
  end

  def initaltize_appotinment(scheduled_at, mechanic_id)
    AppointmentService.new(job, scheduled_at: scheduled_at, mechanic_id: mechanic_id)
  end
end
