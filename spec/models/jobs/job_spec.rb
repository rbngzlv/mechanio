require 'spec_helper'

describe Job do

  let(:user) { create :user }
  let(:car)  { create :car, user: user }
  let(:job)  { build :job, user: user, car: car }
  let(:job_with_service) { create :job, :with_service }
  let(:job_with_repair)  { create :job, :with_repair }

  it { should belong_to :user }
  it { should belong_to :car }
  it { should belong_to :location }
  it { should belong_to :mechanic }
  it { should belong_to :credit_card }
  it { should belong_to :discount }
  it { should have_many :tasks }
  it { should have_one :appointment }
  it { should have_one :event }
  it { should have_one :payout }
  it { should have_one :rating }

  it { should validate_presence_of :user }
  it { should validate_presence_of :car }
  it { should validate_presence_of :location }
  it { should validate_presence_of :tasks }
  it { should validate_presence_of :contact_email }
  it { should validate_presence_of :contact_phone }

  it { should allow_value('0412345678').for(:contact_phone) }
  it { should_not allow_value('12345678').for(:contact_phone) }
  it { should_not allow_value('04123456').for(:contact_phone) }

  context 'scopes' do
    let(:estimated_job)  { create :job, :with_service, :estimated }
    let(:assigned_job)   { create :job, :with_service, :assigned  }
    let(:completed_job)  { create :job, :with_service, :completed }
    let(:rated_job)      { create :job, :with_service, :completed, :rated, scheduled_at: Time.now.advance(hours: 1) }

    it 'finds scoped jobs' do
      Job.estimated.should eq [estimated_job]
      Job.assigned.should  eq [assigned_job]
      Job.completed.should eq [rated_job, completed_job]
      Job.unrated.should   eq [completed_job]
    end
  end

  it 'builds title from tasks' do
    service = build(:service)
    job.tasks << service
    job.set_title.should eq service.title

    job.tasks << build(:repair)
    job.set_title.should eq "#{service.title} and repair"

    job.tasks << build(:inspection)
    job.set_title.should eq "#{service.title}, repair, and inspection"

    job.tasks = [build(:repair)]
    job.set_title.should eq 'Repair'
  end

  it 'sets uid on job creation' do
    job_with_service.uid.length.should >= 9
  end

  it 'builds task association with correct STI subclass' do
    job.tasks_attributes = [build(:service).attributes, build(:repair).attributes]
    job.save!

    job.tasks[0].should be_a Service
    job.tasks[1].should be_a Repair
  end

  it 'associates car with user when creating car via nested_attributes' do
    job = Job.create(job_attributes_with_user)

    job.car.user_id.should eq job.user_id
  end

  it 'updates car when via nested_attributes' do
    job_attributes[:car_attributes] = {
      id: car.id,
      last_service_kms: '10000'
    }
    expect { Job.create(job_attributes) }.to_not change{ Car.count }
    car.reload.last_service_kms.should eq 10000
  end

  it 'determines if there is a service task' do
    job_with_service.has_service?.should be_true
    job_with_repair.has_service?.should be_false
    job.has_service?.should be_false
  end

  it 'determines is there is a repair task' do
    job_with_service.has_repair?.should be_false
    job_with_repair.has_repair?.should be_true
    job.has_repair?.should be_false
  end

  describe '#client_name' do
    it 'displays users full name' do
      job = build(:job, user: build(:user, first_name: 'John', last_name: 'Doe'))
      job.client_name.should eq 'John Doe'
    end

    it 'displays dash when user is not present' do
      job = build(:job, user: nil)
      job.client_name.should eq '-'
    end
  end

  describe '#location_geocoded?' do
    it 'is false when location is not geocoded' do
      job.location = build_stubbed(:location)
      expect(job.location_geocoded?).to be_false
    end

    it 'is true when location is geocoded' do
      job.location = build_stubbed(:location, :with_coordinates)
      expect(job.location_geocoded?).to be_true
    end
  end

  specify 'deleting a job also deletes its calendar event' do
    job = create :job, :assigned, :with_service, :with_event
    expect {
      job.destroy!
    }.to change { Job.count }.by(-1)
  end

  describe '#can_be_completed?' do
    it 'is true when appointment is in the past' do
      job = build :job, :assigned, assigned_at: DateTime.yesterday
      job.can_be_completed?.should be_false
    end

    it 'is false when appointment is in future' do
      job = build :job, :assigned, assigned_at: DateTime.tomorrow
      job.can_be_completed?.should be_false
    end

    it 'is false when a job is already completed' do
      job = build :job, :assigned, assigned_at: DateTime.yesterday, completed_at: DateTime.yesterday
      job.can_be_completed?.should be_false
    end
  end

  def job_attributes_with_user
    job_attributes.merge(user: user)
  end
end
