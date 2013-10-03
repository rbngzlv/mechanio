require 'spec_helper'

describe SymptomCategory do

  it { should have_many :symptoms }

  it { should validate_presence_of :description }
end
