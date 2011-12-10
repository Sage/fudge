require 'spec_helper'

describe Fudge::FudgeFile::Tasks::Rake do
  subject { described_class.new 'db:migrate' }

  it { should be_registered_as :rake }

  describe :run do
    it "should run rake with the given args" do
      subject.should_receive(:system).with('rake db:migrate')

      subject.run
    end
  end
end
