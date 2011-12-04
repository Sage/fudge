require 'spec_helper'

describe Fudge::FudgeFile::Tasks::Rspec do
  it { should be_registered_as :rspec }

  describe :run do
    it "should run rspec with the path of spec/ by default" do
      subject.should_receive(:system).with('rspec spec/')

      subject.run
    end

    it "should allow configuring of the directory to run specs for" do
      subject = described_class.new(:path => 'foo/ bar/')
      subject.should_receive(:system).with('rspec foo/ bar/')

      subject.run
    end

    it "should return the result of the system call" do
      subject.stub(:system).and_return(:foo)

      subject.run.should == :foo
    end
  end
end
