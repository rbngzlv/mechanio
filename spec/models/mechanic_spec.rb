require 'spec_helper'

describe Mechanic do

  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should validate_presence_of :dob }
  it { should validate_presence_of :street_address }
  it { should validate_presence_of :suburb }
  it { should validate_presence_of :state_id }
  it { should validate_presence_of :postcode }
  it { should validate_presence_of :driver_license }
  it { should validate_presence_of :license_state_id }
  it { should validate_presence_of :license_expiry }

  it { should belong_to :state }
end
