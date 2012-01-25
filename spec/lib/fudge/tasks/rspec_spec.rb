require 'spec_helper'

describe Fudge::Tasks::Rspec do
  it { should be_registered_as :rspec }
  it { should be_a Fudge::Tasks::ShellWithCoverage }

  describe :run do
    it "should turn on color if not specified" do
      subject.should run_command_with '--tty'
    end

    it "should turn off color if specified" do
      described_class.new(:color => false).should run_command_without '--tty'
    end

    it "should append any arguments passed in" do
      described_class.new('foobar', :color => false).should run_command 'rspec foobar'
    end

    it "should default the arguments to spec/" do
      described_class.new(:color => false).should run_command 'rspec spec/'
    end
  end

  describe :coverage do
    it { should check_for_coverage_using ') covered' }
  end
end
