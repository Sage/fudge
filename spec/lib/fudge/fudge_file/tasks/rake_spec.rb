require 'spec_helper'

describe Fudge::FudgeFile::Tasks::Rake do
  subject { described_class.new 'db:migrate' }

  it { should be_registered_as :rake }

  describe :run do
    it "should run rake with the given args" do
      Fudge::FudgeFile::Utils::CommandRunner.any_instance.should_receive(:run).with('rake db:migrate')

      subject.run
    end
  end
end
