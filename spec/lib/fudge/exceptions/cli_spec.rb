require 'spec_helper'

module Fudge::Exceptions::Cli

  describe CommandNotFound do
    subject { described_class.new :foo }

    it { should be_a Fudge::Exceptions::Base }

    it "should take a command name as a parameter" do
      expect { described_class.new }.to raise_error ArgumentError
    end

    describe :to_s do
      it "should return a human readable description of the error" do
        subject.to_s.should == "No command found with name 'foo'"
      end
    end
  end

  describe CommandNotGiven do
    it { should be_a Fudge::Exceptions::Base }

    describe :to_s do
      it "should return a human readable description of the error" do
        subject.to_s.should == "No command given"
      end
    end
  end

end
