require 'spec_helper'

describe UsersJobReceipt do

  let(:job) { build_stubbed :job, :with_service, :completed }

  subject { UsersJobReceipt.new(job) }

  it 'generates a PDF' do
    subject.to_pdf.should start_with '%PDF'
  end
end
