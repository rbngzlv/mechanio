require 'spec_helper'

describe TaskItem do

  it { should belong_to :task }
  it { should belong_to :itemable }

  it 'validates itemable_type association' do
    subject.itemable_type = 'UnexistingClass'
    expect { subject.validate_itemable_type }.to raise_error ActiveRecord::AssociationTypeMismatch

    subject.itemable_type = 'Job'
    expect { subject.validate_itemable_type }.to raise_error ActiveRecord::AssociationTypeMismatch

    subject.itemable_type = 'FixedAmount'
    expect { subject.validate_itemable_type}.to_not raise_error
  end

  it 'builds itemable from nested attributes' do
    item = TaskItem.new(
      itemable_type: 'FixedAmount',
      itemable_attributes: {
        description: 'Description',
        cost: '123'
      }
    )
    item.itemable.should be_a FixedAmount
  end

  it 'deletes itemable on delete' do
    item = create :task_item, itemable: build(:fixed_amount)
    expect { item.destroy }.to change { FixedAmount.count }.by(-1)
  end

  it 'delegates cost to itemable' do
    subject.stub(:itemable).and_return double(cost: 123)
    subject.cost.should eq 123
  end
end
