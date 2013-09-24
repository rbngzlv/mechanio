require 'spec_helper'

describe Model do

  it { should validate_presence_of :name }

  it { should belong_to :make }
  it { should have_many :model_variations }

  it '#to_options' do
    model = create :model
    Model.to_options(make_id: model.make_id).should eq [{ id: model.id, name: model.name }]
  end
end
