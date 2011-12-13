require 'spec_helper'

describe Fudge::Exceptions::BuildFailed do
  it { should be_a Fudge::Exceptions::Base }

  describe :to_s do
    it "should return a human readable description of the error" do
      subject.to_s.should == "Build failed"
    end
  end
end
