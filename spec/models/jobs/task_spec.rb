require 'spec_helper'

describe Task do

  it { should belong_to :job }
  it { should have_many :task_items }
end
