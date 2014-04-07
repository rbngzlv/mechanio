require 'spec_helper'

describe UserCreateJobService do

  let(:user)            { create :user }
  let(:temporary_job)   { create_temporary_job }

  describe '#create_job' do
    it 'creates job' do
      job = service(user, job_attributes).create_job

      job.reload.status.should eq 'estimated'
      job.user_id.should eq user.id
      job.serialized_params.should be_nil
    end

    it 'creates temporary job' do
      job = service(nil, job_attributes).create_job

      job.reload.status.should eq 'temporary'
      job.user_id.should be_nil
      job.serialized_params.should_not be_nil
    end

    it 'raises exception when temporary job is invalid' do
      invalid_attrs = job_attributes
      invalid_attrs[:location_attributes] = {}

      expect { service(nil, invalid_attrs).create_job }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  specify '#convert_from_temporary' do
    job = service(user, nil).convert_from_temporary(temporary_job.id)

    job.reload.id.should eq temporary_job.id
    job.status.should eq 'estimated'
    job.user_id.should eq user.id
  end

  def service(user, params)
    UserCreateJobService.new(user, { job: params })
  end
end
