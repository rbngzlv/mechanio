require 'spec_helper'

describe Authentication do
  let(:email)     { 'example@example.com' }
  let(:provider)  { 'facebook' }
  let(:uid)       { '12312kjhg1232' }
  let(:user)            { create :user, email: email }
  let(:authentication)  { create :authentication, provider: provider, uid: uid, user: user }

  let(:incomplete_data) do
    {
      provider: provider,
      uid: uid,
      info: {
        email: email
      }
    }.with_indifferent_access
  end

  let(:data) do
    incomplete_data.merge({ info: {
      email: email,
      first_name: 'Eugene',
      last_name: 'Maslenkov'
    } })
  end


  it { should belong_to :user }

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :uid }
  it { should validate_presence_of :provider }
  it { should validate_uniqueness_of :uid }

  describe '#connect' do
    context 'logged out' do
      subject { Authentication.connect(data, nil) }

      describe 'new user connects new account' do
        it 'creates authentication' do
          expect { subject }.to change { Authentication.count }.by 1
        end

        it 'creates user' do
          expect { subject }.to change { User.count }.by 1
        end

        it 'is successfull' do
          subject.error.should be_nil
        end
      end

      describe 'new user connects new account with incomplete data' do
        subject { Authentication.connect(incomplete_data, nil) }

        it 'does not create authentication' do
          expect { subject }.to_not change { Authentication.count }
        end

        it 'does not create user' do
          expect { subject }.to_not change { User.count }
        end

        it 'is unsuccessfull' do
          subject.error.should eq :user_invalid
        end
      end

      describe 'existing user connects new account' do
        before do
          user
        end

        it 'creates authentication' do
          expect { subject }.to change { Authentication.count }.by 1
        end

        it 'does not create a user' do
          expect { subject }.to_not change { User.count }
        end

        it 'finds existing user' do
          subject.user.should eq user
        end

        it 'is successfull' do
          subject.error.should be_nil
        end
      end

      describe 'existing user connects existing account' do
        before do
          user
          authentication
        end

        it 'does not create authentication' do
          expect { subject }.to_not change { Authentication.count }
        end

        it 'does not create a user' do
          expect { subject }.to_not change { User.count }
        end

        it 'finds existing user' do
          subject.user.should eq user
        end

        it 'finds existing authentication' do
          subject.should eq authentication
        end

        it 'is successfull' do
          subject.error.should be_nil
        end
      end
    end

    context 'logged in' do
      subject { Authentication.connect(data, user) }

      before do
        user
      end

      describe 'user connects new account' do
        it 'creates authentication' do
          expect { subject }.to change { Authentication.count }.by 1
        end

        it 'does not create a user' do
          expect { subject }.to_not change { User.count }
        end

        it 'finds existing user' do
          subject.user.should eq user
        end

        it 'is successfull' do
          subject.error.should be_nil
        end
      end

      describe 'user connects existing account' do
        before do
          authentication
        end

        it 'does not create authentication' do
          expect { subject }.to_not change { Authentication.count }
        end

        it 'does not create a user' do
          expect { subject }.to_not change { User.count }
        end

        it 'is unsuccessfull' do
          subject.error.should eq :already_connected
        end
      end
    end
  end

  specify '#provider_name' do
    auth = build :authentication, provider: 'facebook'
    auth.provider_name.should eq 'Facebook'

    auth = build :authentication, provider: 'google_oauth2'
    auth.provider_name.should eq 'Gmail'

    Authentication.provider_name('facebook').should be_eql 'Facebook'
    Authentication.provider_name('google_oauth2').should be_eql 'Gmail'
  end
end
