require 'spec_helper'

describe Authentication do
  it { should belong_to :user }

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :uid }
  it { should validate_presence_of :provider }
  it { should validate_uniqueness_of :uid }

  describe '#find_or_create_from_oauth' do
    let(:hash) do
      {
        'provider' => 'facebook',
        'uid' => 'slkdfajsldkjflkasdjf',
        'info' => {
          'first_name' => 'Eugene',
          'last_name' => 'Maslenkov',
          'email' => 'example@example.com'
        }
      }
    end

    context 'if user with auth email not exists' do
      it 'creates user' do
        expect do
          Authentication.find_or_create_from_oauth(hash)
        end.to change { User.count }.by(1)
      end

      it 'creates authentication' do
        expect do
          Authentication.find_or_create_from_oauth(hash)
        end.to change { Authentication.count }.by(1)
      end
    end

    context 'if user with auth email exists' do
      before { create :user, email: 'example@example.com' }

      it 'should not create user' do
        expect do
          Authentication.find_or_create_from_oauth(hash)
        end.not_to change { User.count }
      end

      it 'creates authentication' do
        expect do
          Authentication.find_or_create_from_oauth(hash)
        end.to change { Authentication.count }.by(1)
      end
    end

    context 'should create user/authentication only once' do
      before do
        user = create :user, email: 'example@example.com'
        Authentication.create(user: user, uid: hash['uid'], provider: hash['provider'])
      end

      it 'should not create authentication' do
        expect do
          Authentication.find_or_create_from_oauth(hash)
        end.not_to change { Authentication.count }
      end

      it 'should not create user' do
        expect do
          Authentication.find_or_create_from_oauth(hash)
        end.not_to change { User.count }
      end
    end
  end
end
