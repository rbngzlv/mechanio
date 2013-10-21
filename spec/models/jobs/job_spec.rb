require 'spec_helper'

describe Job do

  let(:user) { create :user}
  let(:car)  { create :car, user: user }
  let(:job)  { build :job, user: user, car: car }
  let(:job_with_service) { create :job_with_service }

  it { should belong_to :user }
  it { should belong_to :car }
  it { should belong_to :mechanic }
  it { should belong_to :location }
  it { should have_many :tasks }

  it { should validate_presence_of :user }
  it { should validate_presence_of :car }
  it { should validate_presence_of :location }
  it { should validate_presence_of :tasks }
  it { should validate_presence_of :contact_email }
  it { should validate_presence_of :contact_phone }

  it '#create_temporary' do
    tmp = Job.create_temporary(job: attrs)
    tmp.reload.serialized_params.should eq ({ job: attrs })
    tmp.status.should eq 'temporary'
  end

  it '#convert_from_temporary' do
    tmp = Job.create_temporary(job: attrs)
    tmp.reload.status.should eq 'temporary'

    job = Job.convert_from_temporary(tmp.id, user)
    job.reload.status.should eq 'pending'
    job.tasks.count.should eq 2
    job.cost.should eq 475
  end

  describe '#assign_mechanic' do
    let(:mechanic) { create :mechanic }

    it 'return true if success' do
      job_with_service.assign_mechanic(mechanic_id: mechanic.id, scheduled_at: DateTime.now).should be_true
    end

    it 'return false if sheduled time doesnot given' do
      job_with_service.assign_mechanic(mechanic_id: mechanic.id).should be_false
    end

    it 'throw exception if mechanic doesnot given' do
      expect do
        job_with_service.assign_mechanic scheduled_at: DateTime.now
      end.to raise_error
    end

    it 'throw exception if mechanic doesnot presence' do
      expect do
        job_with_service.assign_mechanic mechanic_id: 10000, scheduled_at: DateTime.now
      end.to raise_error
    end
  end

  it 'builds task association with correct STI subclass' do
    job.tasks_attributes = [build(:service).attributes, build(:repair).attributes]
    job.save!

    job.tasks[0].should be_a Service
    job.tasks[1].should be_a Repair
  end

  it 'associates car with user when creating car via nested_attributes' do
    job = user.jobs.create(attrs)

    job.car.user_id.should_not be_nil
    job.car.user_id.should eq job.user_id
  end

  it 'sums tasks costs' do
    job_with_service.cost.should eq 350
  end

  it 'sums tasks costs when creating from nested_attributes' do
    job = user.jobs.create!(attrs)
    job.cost.should eq 475
  end

  it 'sets title from the first task before save' do
    job_with_service.title.should eq job_with_service.tasks.first.title
  end

  specify '#pending should call send_new_job_email' do
    job_with_service.should_receive( :send_new_job_email )
    job_with_service.pending
  end

  specify '#send_new_job_email should call mailer' do
    mailer = double(deliver: true)
    AdminMailer.should_receive(:new_job).with(job_with_service).and_return(mailer)
    job_with_service.send(:send_new_job_email)
  end

  it 'determines if there is a service task' do
    job_with_service.has_service?.should be_true
    job.has_service?.should be_false
  end

  def attrs
    repair_item = attributes_for(:task_item, itemable_type: 'Labour', itemable_attributes: attributes_for(:labour))

    @attrs ||= attributes_for(:job).merge({
      location_attributes: attributes_for(:location, state_id: create(:state).id),
      tasks_attributes: [
        attributes_for(:service, service_plan_id: create(:service_plan).id),
        attributes_for(:repair, task_items_attributes: [repair_item])
      ],
      car_attributes: { year: '2000', model_variation_id: create(:model_variation).id }
    })
  end
end
