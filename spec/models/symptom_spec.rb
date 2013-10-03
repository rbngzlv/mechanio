require 'spec_helper'

describe Symptom do

  it { should belong_to :symptom_category }

  it { should validate_presence_of :description }
end
