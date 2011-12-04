require 'spec_helper'

describe Fudge::Exceptions::TaskNotFound do
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
