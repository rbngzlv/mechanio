require 'spec_helper'

describe Car do

  let(:car) { build :car }

  it { should belong_to :user }
  it { should belong_to :model_variation }

  it { should validate_presence_of :user }
  it { should validate_presence_of :model_variation }
  it { should validate_presence_of :year }

  it 'copies display_title from model_variation on save' do
    car.display_title.should eq nil
    car.save
    car.display_title.should_not be_empty
    car.display_title.should eq "#{car.year} #{car.model_variation.display_title}"
  end
end
