require 'spec_helper'

describe Service do

  it { should belong_to :service_plan }

  it { should validate_presence_of :service_plan }
end
