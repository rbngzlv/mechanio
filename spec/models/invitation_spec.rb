require 'spec_helper'

describe Invitation do

  let(:user) { create :user }

  it { should belong_to :user }
  it { should belong_to :sender }

  it { should validate_presence_of :email }

  it 'validates user presence when completed' do
    invitation = Invitation.create(email: 'email@host.com', accepted_at: Time.zone.now)
    invitation.persisted?.should be_false

    invitation = Invitation.create(email: 'email@host.com', user: user, accepted_at: Time.zone.now)
    invitation.persisted?.should be_true
  end

  it 'does not validate user presence when pending' do
    invitation = Invitation.create(email: 'email@host.com')
    invitation.persisted?.should be_true
  end
end
