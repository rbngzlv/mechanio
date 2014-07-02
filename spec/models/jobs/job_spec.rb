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
    let!(:estimated_job)      { create :job, :with_service, :estimated }
    let!(:assigned_job)       { create :job, :with_service, :assigned  }
    let!(:completed_job)      { create :job, :with_service, :completed, scheduled_at: Time.now }
    let!(:charged_job)        { create :job, :with_service, :charged, scheduled_at: Time.now.advance(days: 1) }
    let!(:charge_failed_job)  { create :job, :with_service, :charge_failed, scheduled_at: Time.now.advance(days: 2) }
    let!(:paid_out_job)       { create :job, :with_service, :paid_out, scheduled_at: Time.now.advance(days: 3) }
    let!(:rated_job)          { create :job, :with_service, :rated, scheduled_at: Time.now.advance(days: 4) }

    specify '#estimated' do
      Job.estimated.should eq [estimated_job]
    end

    specify '#assigned' do
      Job.assigned.should eq [assigned_job]
    end

    specify '#completed' do
      Job.completed.should eq [rated_job, completed_job]
    end

    specify '#past' do
      Job.past.should eq [rated_job, paid_out_job, charge_failed_job, charged_job, completed_job]
    end

    specify '#charged' do
      Job.charged.should eq [charged_job]
    end

    specify '#charge_failed' do
      Job.charge_failed.should eq [charge_failed_job]
    end

    specify '#paid_out' do
      Job.paid_out.should eq [paid_out_job]
    end

    specify '#rated' do
      Job.rated.should eq [rated_job]
    end

    specify '#unrated' do
      Job.unrated.should eq [paid_out_job, charge_failed_job, charged_job, completed_job]
    end

    specify '#past?' do
      estimated_job.past?.should      be_false
      assigned_job.past?.should       be_false
      completed_job.past?.should      be_true
      charged_job.past?.should        be_true
      charge_failed_job.past?.should  be_true
      paid_out_job.past?.should       be_true
      rated_job.past?.should          be_true
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

  context '#set_search_terms' do
    let(:completed_job) { build :job, :completed, :with_service }
    let(:pending_job)   { build :job, :pending, :with_repair }

    it 'sets search terms on save' do
      completed_job.save
      completed_job.search_terms.should eq '0410123456 john user joe mechanic 0420123456 palm beach 55, sydney, nsw 2012'
    end

    it 'sets search terms when there is no mechanic' do
      pending_job.set_search_terms.should eq '0410123456 john user palm beach 55, sydney, nsw 2012'
    end
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
    job = create :job, :assigned, :with_service
    expect {
      job.destroy!
    }.to change { Job.count }.by(-1)
  end

  describe '#can_complete?' do
    it 'is true when appointment is in the past' do
      job = build :job, :assigned, assigned_at: DateTime.yesterday
      job.can_complete?.should be_false
    end

    it 'is false when appointment is in future' do
      job = build :job, :assigned, assigned_at: DateTime.tomorrow
      job.can_complete?.should be_false
    end

    it 'is false when a job is already completed' do
      job = build :job, :assigned, assigned_at: DateTime.yesterday, completed_at: DateTime.yesterday
      job.can_complete?.should be_false
    end
  end

  def job_attributes_with_user
    job_attributes.merge(user: user)
  end
end
