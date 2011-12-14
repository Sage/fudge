require 'spec_helper'

describe Fudge::FudgeFile::Tasks::Rspec do
  it { should be_registered_as :rspec }

  describe :run do
    it "should run rspec with the path of spec/ by default" do
      Fudge::FudgeFile::Utils::CommandRunner.any_instance.should_receive(:run).with('rspec --tty spec/')

      subject.run
    end
  end
end
