require 'spec_helper'

describe Symptom do

  it { should belong_to :symptom }

  it { should validate_presence_of :description }

  it 'builds tree' do
    parent    = create :symptom, description: 'Looks like'
    symptom   = create :symptom, description: 'One', parent_id: parent.id
    symptom2  = create :symptom, description: 'Two', parent_id: parent.id
    parent2   = create :symptom, description: 'Sounds like'
    symptom3  = create :symptom, description: 'Three', parent_id: parent2.id

    tree = Symptom.tree
    tree[parent.id]['symptoms'][0]['id'].should eq symptom.id
    tree[parent.id]['symptoms'][1]['id'].should eq symptom2.id
    tree[parent2.id]['symptoms'][0]['id'].should eq symptom3.id
  end
end
