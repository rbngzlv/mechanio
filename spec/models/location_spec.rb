require 'spec_helper'

describe Location do

  subject { build :location }

  it { should belong_to :state }

  it { should validate_presence_of :state }
  it { should validate_presence_of :address }
  it { should validate_presence_of :suburb }
  it { should validate_presence_of :postcode }
  it { should allow_value('0200').for(:postcode) }
  it { should_not allow_value('0300').for(:postcode).with_message('is not a valid postcode') }
end