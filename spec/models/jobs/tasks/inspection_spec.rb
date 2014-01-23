require 'spec_helper'

describe Inspection do

  let(:inspection) { build :inspection }

  it { should validate_presence_of :title }
  it { should validate_presence_of :description }

  it 'sets cost' do
    expect { inspection.set_cost }.to change { inspection.cost }.from(nil).to(80)
  end
end
