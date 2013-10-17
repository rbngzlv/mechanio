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
    job = build :job, user: nil, car: nil
    params = job.attributes
    params[:tasks_attributes] = [build(:service).attributes]
    params[:car_attributes] = build(:car, user: nil).attributes

    tmp = Job.create_temporary(job: attrs)
    tmp.reload.serialized_params.should eq ({ job: attrs })
    tmp.status.should eq 'temporary'
  end

  describe '#assign_mechanic' do
    let(:mechanic) { create :mechanic }

    it 'return true' do
      job_with_service.assign_mechanic(mechanic_id: mechanic.id, scheduled_at: DateTime.now).should be_true
    end

    context 'return false' do
      it { job_with_service.assign_mechanic(scheduled_at: DateTime.now).should be_false }
      it { job_with_service.assign_mechanic(mechanic_id: mechanic.id).should be_false }
    end

    it 'throw exception' do
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

  it 'sets title from the first task before save' do
    job_with_service.title.should eq job_with_service.tasks.first.title
  end

  it 'determines if there is a service task' do
    job_with_service.has_service?.should be_true
    job.has_service?.should be_false
  end

  def attrs
    @attrs ||= attributes_for(:job).merge({
      location_attributes: attributes_for(:location, state_id: create(:state).id),
      tasks_attributes: [attributes_for(:service, service_plan_id: create(:service_plan).id)],
      car_attributes: { year: '2000', model_variation_id: create(:model_variation).id }
    })
  end
end
