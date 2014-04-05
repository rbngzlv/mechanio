require 'spec_helper'

describe UserCreateJobService do

  let(:user) { create :user }
  let(:tmp_job) { service(nil, attrs).create_job }

  describe '#create_job' do
    it 'creates job' do
      job = service(user, attrs).create_job

      job.reload.status.should eq 'estimated'
      job.user_id.should eq user.id
      job.serialized_params.should be_nil
    end

    it 'creates temporary job' do
      job = service(nil, attrs).create_job

      job.reload.status.should eq 'temporary'
      job.user_id.should be_nil
      job.serialized_params.should_not be_nil
    end
  end

  specify '#convert_from_temporary' do
    tmp_job.reload.status.should eq 'temporary'
    job = service(user, nil).convert_from_temporary(tmp_job.id)

    job.reload.id.should eq tmp_job.id
    job.status.should eq 'estimated'
    job.user_id.should eq user.id
  end

  def service(user, params)
    UserCreateJobService.new(user, { job: params })
  end

  def attrs
    @attrs ||= attributes_for(:job).merge({
      location_attributes: attributes_for(:location, state_id: create(:state).id),
      tasks_attributes: [
        attributes_for(:service, service_plan_id: create(:service_plan).id),
        attributes_for(:repair, task_items_attributes: [
          attributes_for(:task_item, itemable_type: 'Labour', itemable_attributes: attributes_for(:labour))
        ])
      ],
      car_attributes: { year: '2000', model_variation_id: create(:model_variation).id, last_service_kms: '10000' }
    })
  end
end
