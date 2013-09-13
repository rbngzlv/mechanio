require 'spec_helper'

describe Car do

  it { should belong_to :user }
  it { should belong_to :model_variation }

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :model_variation_id }
  it { should validate_presence_of :year }
end
