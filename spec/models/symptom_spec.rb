require 'spec_helper'

describe Symptom do

  it { should belong_to :symptom }

  it { should validate_presence_of :description }
end
