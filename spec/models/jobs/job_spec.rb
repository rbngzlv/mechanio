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
  it { should have_many :tasks }
  it { should have_one :appointment }
  it { should have_one :event }
  it { should have_one :payout }

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

    it 'finds scoped jobs' do
      Job.estimated.should eq [estimated_job]
      Job.assigned.should  eq [assigned_job]
      Job.completed.should eq [completed_job]
    end
  end

  it '#sanitize_and_create' do
    Job.any_instance.should_receive(:notify_estimated)
    job = Job.sanitize_and_create(user, job: attrs)
    verify_estimated_job(job)
  end

  it '#create_temporary' do
    Job.any_instance.should_not_receive(:notify_pending)
    Job.any_instance.should_not_receive(:notify_estimated)
    tmp = Job.create_temporary(job: attrs)
    tmp.reload.serialized_params.should eq ({ job: attrs })
    tmp.status.should eq 'temporary'
  end

  it '#convert_from_temporary' do
    tmp = Job.create_temporary(job: attrs)
    tmp.reload.status.should eq 'temporary'

    Job.any_instance.should_receive(:notify_estimated)
    job = Job.convert_from_temporary(tmp.id, user)
    verify_estimated_job(job)
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
    job_with_service.uid.length.should eq 10
  end

  it 'builds task association with correct STI subclass' do
    job.tasks_attributes = [build(:service).attributes, build(:repair).attributes]
    job.save!

    job.tasks[0].should be_a Service
    job.tasks[1].should be_a Repair
  end

  it 'associates car with user when creating car via nested_attributes' do
    job = Job.sanitize_and_create(user, job: attrs)

    job.car.user_id.should_not be_nil
    job.car.user_id.should eq job.user_id
  end

  it 'updates car when via nested_attributes' do
    attrs[:car_attributes] = {
      id: car.id,
      last_service_kms: '10000'
    }
    expect { Job.sanitize_and_create(user, job: attrs) }.to_not change{ Car.count }
    car.reload.last_service_kms.should eq 10000
  end

  it 'sums tasks costs' do
    job_with_service.cost.should eq 350
  end

  it 'sums tasks costs when creating from nested_attributes' do
    job = Job.sanitize_and_create(user, job: attrs)
    job.cost.should eq 475
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

  context 'updating task' do
    it 'should be pending when some tasks have unknown cost' do
      attrs[:tasks_attributes][1].delete(:task_items_attributes)

      job.update_attributes(attrs)
      job.reload.status.should eq 'pending'
      job.cost.should be_nil
    end

    it 'should notify when quote becomes available' do
      job = create :job, :pending
      job.reload.status.should eq 'pending'

      attrs[:tasks_attributes][1][:id] = job.tasks.first.id
      job.should_receive(:notify_estimated)
      job.update_attributes(attrs)
      job.reload.status.should eq 'estimated'
    end

    it 'should notify when quote changes' do
      job = job_with_service
      job.status.should eq 'estimated'
      job.cost.should eq 350

      job.should_receive(:notify_quote_changed)
      job.update_attributes(attrs)
      job.status.should eq 'estimated'
      job.cost.should eq 825
    end
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

  def verify_estimated_job(job)
    job.reload.status.should eq 'estimated'
    job.tasks.count.should eq 2
    job.cost.should eq 475
  end

  def attrs
    repair_item = attributes_for(:task_item, itemable_type: 'Labour', itemable_attributes: attributes_for(:labour))

    @attrs ||= attributes_for(:job).merge({
      location_attributes: attributes_for(:location, state_id: create(:state).id),
      tasks_attributes: [
        attributes_for(:service, service_plan_id: create(:service_plan).id),
        attributes_for(:repair, task_items_attributes: [repair_item])
      ],
      car_attributes: { year: '2000', model_variation_id: create(:model_variation).id, last_service_kms: '10000' }
    })
  end
end
