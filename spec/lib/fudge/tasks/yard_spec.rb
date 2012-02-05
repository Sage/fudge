require 'spec_helper'

describe Fudge::Tasks::Yard do
  subject { described_class.new }

  it { should be_registered_as :yard }

  describe :run do
    it "should run yard with any arguments passed in" do
      described_class.new('-r YardREADME.md').should run_command 'yard -r YardREADME.md'
    end
  end

  describe :coverage do
    subject { described_class.new :coverage => 99 }

    it { should_not succeed_with_output 'some dummy output with no coverage' }
    it { should_not succeed_with_output '98.99999% documented' }
    it { should_not succeed_with_output '0.00% documented' }
    it { should succeed_with_output '99.99999% documented' }
    it { should succeed_with_output '100.0% documented' }
  end
end
