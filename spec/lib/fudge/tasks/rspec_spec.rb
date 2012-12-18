require 'spec_helper'

describe Fudge::Tasks::Rspec do
  it { should be_registered_as :rspec }

  describe :run do
    it "should turn on color if not specified" do
      subject.should run_command /--tty/
    end

    it "should turn off color if specified" do
      described_class.new(:color => false).should_not run_command /--tty/
    end

    it "should append any arguments passed in" do
      task = described_class.new('foobar', :color => false)
      task.should run_command 'rspec foobar'
    end

    it "should default the arguments to spec/" do
      described_class.new(:color => false).should run_command 'rspec spec/'
    end

  end

  it_should_behave_like 'bundle aware'

  describe :coverage do
    subject { described_class.new :coverage => 99 }

    it { should_not succeed_with_output 'some dummy output with no coverage' }
    it { should_not succeed_with_output '98.99999%) covered' }
    it { should_not succeed_with_output '0.00%) covered' }
    it { should succeed_with_output '99.99999%) covered' }
    it { should succeed_with_output '100.0%) covered' }
#    it { should succeed_with_output '0 / 0 LOC (0.0%) covered' } #no methods to cover
  end
end
