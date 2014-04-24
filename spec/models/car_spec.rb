require 'spec_helper'

describe Car do

  let(:car) { build :car }

  it { should belong_to :user }
  it { should belong_to :model_variation }

  it { should validate_presence_of :user }
  it { should validate_presence_of :model_variation }
  it { should validate_presence_of :year }

  it 'validates last service' do
    car.last_service_kms = 12000
    car.last_service_date = nil
    car.should be_valid

    car.last_service_kms = nil
    car.last_service_date = '2010-11-02'
    car.should be_valid

    car.last_service_kms = nil
    car.last_service_date = nil
    car.should_not be_valid
  end

  it 'copies display_title from model_variation on save' do
    car.display_title.should eq nil
    car.save
    car.display_title.should_not be_empty
    car.display_title.should eq "#{car.year} #{car.model_variation.display_title}"
  end

  describe '#destroy' do
    context 'soft delete by adding deleted_at' do
      it 'successfully for cars with temporary and completed jobs' do
        create(:job, :with_service, status: :temporary).car.destroy.should be_true
        create(:job, :completed, :with_service).car.destroy.should be_true
      end

      it 'fails if car has status like pending, estimated or assigned' do
        create(:job, :pending, :with_service).car.destroy.should be_false
        create(:job, :assigned, :with_service).car.destroy.should be_false
        create(:job, :estimated, :with_service).car.destroy.should be_false
      end
    end
  end
end
