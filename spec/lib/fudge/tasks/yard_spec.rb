require 'spec_helper'

describe Fudge::Tasks::Yard do
  subject { described_class.new }

  it { should be_registered_as :yard }
  it { should be_a Fudge::Tasks::ShellWithCoverage }

  describe :run do
    it "should run yard with any arguments passed in" do
      described_class.new('-r YardREADME.md').should run_command 'yard -r YardREADME.md'
    end
  end

  describe :suffix do
    it "should be the yard suffix" do
      subject.send(:suffix).should == ' documented'
    end
  end
end
