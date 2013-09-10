require 'spec_helper'

describe Model do

  it { should validate_presence_of :name }

  it { should belong_to :brand }
  it { should have_many :model_variations }
end
