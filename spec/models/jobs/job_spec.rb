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

  def attrs
    @attrs ||= attributes_for(:job).merge({
      location_attributes: attributes_for(:location, state_id: create(:state).id),
      tasks_attributes: [attributes_for(:service, service_plan_id: create(:service_plan).id)],
      car_attributes: { year: '2000', model_variation_id: create(:model_variation).id }
    })
  end
end
