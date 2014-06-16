require 'spec_helper'

describe Region do
  let(:region) { create :sydney_region }
  let(:suburb) { create :sydney_suburb }

  specify '#states' do
    create :regions_tree

    Region.states.map(&:name).should eq ['NSW']
  end

  specify '#suburbs' do
    Region.suburbs.should eq [suburb]
  end

  describe '#search' do
    specify 'when name is empty' do
      Region.search('').should eq []
      Region.search(nil).should eq []
    end

    specify 'by partial name' do
      Region.search('Syd').should eq [suburb, region]
      Region.search('Sydney reg').should eq [region]
    end
  end
end
