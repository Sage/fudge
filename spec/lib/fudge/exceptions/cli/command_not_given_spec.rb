require 'spec_helper'

describe Fudge::Exceptions::Cli::CommandNotGiven do
  it { should be_a Fudge::Exceptions::Base }

  describe :to_s do
    it "should return a human readable description of the error" do
      subject.to_s.should == "No command given"
    end
  end
end
