require 'spec_helper'

describe Job do

  let(:user) { create :user }
  let(:car)  { create :car, user: user }
  let(:job)  { build :job, user: user, car: car }
  let(:job_with_service) { create :job, :with_service }
  let(:job_with_repair)  { create :job, :with_repair }

  it { should belong_to :user }
  it { should belong_to :car }
  it { should belong_to :mechanic }
  it { should belong_to :location }
  it { should have_many :tasks }
  it { should have_one :event }

  it { should validate_presence_of :user }
  it { should validate_presence_of :car }
  it { should validate_presence_of :location }
  it { should validate_presence_of :tasks }
  it { should validate_presence_of :contact_email }
  it { should validate_presence_of :contact_phone }

  it { should allow_value('0412345678').for(:contact_phone) }
  it { should_not allow_value('12345678').for(:contact_phone) }
  it { should_not allow_value('04123456').for(:contact_phone) }

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

  specify '#with_status' do
    job1 = create :job, :with_service, :pending
    job2 = create :job, :with_service, :completed

    Job.with_status(:pending).should eq [job1]
  end

  describe '#assign_mechanic' do
    let(:job) { create :job, :with_service, :with_credit_card }
    let(:mechanic) { create :mechanic }

    it 'return true if success' do
      Job.any_instance.should_receive(:notify_assigned)
      job.assign_mechanic(mechanic_id: mechanic.id, scheduled_at: DateTime.tomorrow).should be_true
    end

    it 'return false if sheduled time doesnot given' do
      Job.any_instance.should_not_receive(:notify_assigned)
      job.assign_mechanic(mechanic_id: mechanic.id).should be_false
    end

    it 'return false if sheduled time in the past' do
      Job.any_instance.should_not_receive(:notify_assigned)
      job.assign_mechanic(mechanic_id: mechanic.id, scheduled_at: Date.yesterday).should be_false
    end

    it 'return false if mechanic unavailable in choosen time' do
      Job.any_instance.should_not_receive(:notify_assigned)
      create :event, mechanic: mechanic, date_start: Date.tomorrow
      job.assign_mechanic(mechanic_id: mechanic.id, scheduled_at: DateTime.tomorrow + 11.hour).should be_false
    end

    it 'throw exception if mechanic doesnot given' do
      Job.any_instance.should_not_receive(:notify_assigned)
      expect do
        job.assign_mechanic(scheduled_at: DateTime.now)
      end.to raise_error
    end

    it 'throw exception if mechanic doesnot presence' do
      Job.any_instance.should_not_receive(:notify_assigned)
      expect do
        job.assign_mechanic(mechanic_id: 10000, scheduled_at: DateTime.now)
      end.to raise_error
    end
  end

  describe 'cancel job' do
    let(:job) { create :assigned_job, :with_event, reason_for_cancel: 'some reason' }

    describe '#cancel' do
      it 'should call cancel_job' do
        Job.any_instance.should_receive(:cancel_job)
        job.cancel
      end

      it 'should validate presence of reason_for_cancel' do
        job.reason_for_cancel = nil
        job.cancel
        job.should_not be_cancelled
      end

      it 'should call notify_cancelled' do
        Job.any_instance.should_receive(:notify_cancelled)
        job.cancel
      end
    end

    describe '#cancel_job' do
      it 'should destroy job event' do
        Event.any_instance.should_receive(:destroy)
        job.cancel_job
      end

      it 'should nullify mechanic' do
        job.status = :cancelled
        job.save
        expect { job.cancel_job }.to change { job.reload.mechanic }.to(nil)
      end
    end

    describe '#notify_cancelled' do
      it 'should call AdminMailer#job_cancelled' do
        AdminMailer.any_instance.should_receive(:job_cancelled)
        job.instance_eval{ notify_cancelled }
      end

      it 'should call UserMailer#job_cancelled' do
        UserMailer.any_instance.should_receive(:job_cancelled)
        job.instance_eval{ notify_cancelled }
      end
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
