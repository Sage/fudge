require 'spec_helper'

module Fudge::Exceptions::Build

  describe BuildFailed do
    it { should be_a Fudge::Exceptions::Base }

    describe :to_s do
      it "should return a human readable description of the error" do
        subject.to_s.should == "Build failed"
      end
    end
  end

  describe TaskNotFound do
    subject { described_class.new :foo }

    it { should be_a Fudge::Exceptions::Base }

    it "should take a task name as a parameter" do
      expect { described_class.new }.to raise_error ArgumentError
    end

    describe :to_s do
      it "should return a human readable description of the error" do
        subject.to_s.should == "No task found with name 'foo'"
      end
    end
  end

end
