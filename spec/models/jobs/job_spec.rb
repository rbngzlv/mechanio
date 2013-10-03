require 'spec_helper'

describe Job do

  let(:user) { create :user}
  let(:car)  { create :car, user: user }
  let(:job)  { build :job, user: user, car: car }

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
    params = job.attributes
    params[:tasks_attributes] = [build(:service).attributes]

    id = Job.create_temporary(params)
    Job.find(id).serialized_params.should eq params
  end

  it 'builds task association with correct STI subclass' do
    job.tasks_attributes = [build(:service).attributes, build(:repair).attributes]
    job.save!

    job.tasks[0].should be_a Service
    job.tasks[1].should be_a Repair
  end
end
