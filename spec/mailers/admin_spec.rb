require 'spec_helper'

describe AdminMailer do
  let(:job) { mock_model Job, id: 1, title: '10000km/1year', user: mock_model(User, email: 'user@host.com', full_name: 'Eugene Maslenkov') }

  describe 'new job email' do
    subject { AdminMailer.new_job(job) }

    before { Admin.stub(:all).and_return([mock_model(Admin, email: 'admin@example.com')]) }

    its(:subject) { should == 'New Job!' }
    its(:from) { should == ["no-reply@mechanio.com"] }
    its(:to) { should == ['admin@example.com'] }

    it 'contains the job title' do
      subject.body.encoded.should match(job.title)
    end

    it 'contains the user full name' do
      subject.body.encoded.should match(job.user.full_name)
    end

    it 'contains the edit admin job path' do
      subject.body.encoded.should match(edit_admin_job_path(job.id))
    end
  end
end
