require 'spec_helper'

describe Make do

  it { should have_many :models }
  it { should have_many :model_variations }

  it { should validate_presence_of :name }
end
