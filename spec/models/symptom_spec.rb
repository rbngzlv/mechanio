require 'spec_helper'

describe Symptom do

  it { should validate_presence_of :description }
end
