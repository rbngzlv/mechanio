require 'spec_helper'

describe ServicePlan do
  include ActionView::Helpers::NumberHelper

  let(:service_plan)        { build :service_plan }
  let(:custom_service_plan) { build :custom_service_plan }
  let(:model_variation)     { create :model_variation }

  it { should belong_to :make }
  it { should belong_to :model }
  it { should belong_to :model_variation }
  it { should have_many :tasks }

  it { should validate_presence_of :cost }
  it { should validate_numericality_of :cost }

  it 'populates make and model from model_variation on save' do
    service_plan = build :service_plan, model_variation: model_variation, make_id: nil, model_id: nil
    service_plan.save
    service_plan.make_id.should eq model_variation.make_id
    service_plan.model_id.should eq model_variation.model_id
  end

  context 'periodic service plan' do
    subject { service_plan }

    it { should validate_uniqueness_of(:kms_travelled).scoped_to(:months, :model_variation_id) }
    it { should validate_presence_of :kms_travelled }
    it { should validate_presence_of :months }
    it { should validate_numericality_of :kms_travelled }
    it { should validate_numericality_of :months }

    it '#display_title' do
      subject.set_display_title
      subject.display_title.should eq "#{number_with_delimiter(subject.kms_travelled)} kms / #{subject.months} months"
    end
  end

  context 'custom service plan' do
    subject { custom_service_plan }

    it { should validate_uniqueness_of(:title).scoped_to(:model_variation_id) }
    it { should_not validate_presence_of :kms_travelled }
    it { should_not validate_presence_of :months }
    it { should_not validate_numericality_of :kms_travelled }
    it { should_not validate_numericality_of :months }

    it '#display_title' do
      subject.set_display_title
      subject.display_title.should eq 'Custom service'
    end
  end

  context 'deleting service plan' do
    specify 'when service plan deleted his id in tasks should became nil' do
      job = create :job, :with_service
      task = job.tasks.first
      service_plan_for_deleting = task.service_plan

      expect { service_plan_for_deleting.destroy }.to change { task.reload.service_plan }.to(nil)
    end
  end
end
