require 'spec_helper'

describe User do

  let(:user) { build :user }

  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it 'combines first and last names into full name' do
    user.full_name.length.should > 0
    user.full_name.should eq "#{user.first_name} #{user.last_name}"
  end
end
