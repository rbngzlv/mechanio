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
end
