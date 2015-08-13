require 'spec_helper'

describe Fudge::Tasks::Cucumber do
  it { is_expected.to be_registered_as :cucumber }

  describe '#run' do
    it 'turns on color if not specified' do
      expect(subject).to run_command /--color/
    end

    it 'turns off color if specified' do
      expect(described_class.new(:color => false)).not_to run_command /--color/
    end

    it 'appends any arguments passed in' do
      task = described_class.new('foobar', :color => false)
      expect(task).to run_command 'cucumber foobar'
    end

    it 'should default the arguments to spec/' do
      expect(described_class.new(:color => false)).to run_command 'cucumber features/'
    end

  end

  it_should_behave_like 'bundle aware'

  describe '#coverage' do
    subject { described_class.new :coverage => 99 }

    it { is_expected.not_to succeed_with_output 'some dummy output with no coverage' }
    it { is_expected.not_to succeed_with_output '98.99999%) covered' }
    it { is_expected.not_to succeed_with_output '0.00%) covered' }
    it { is_expected.to succeed_with_output '99.99999%) covered' }
    it { is_expected.to succeed_with_output '100.0%) covered' }
    it { is_expected.to succeed_with_output "Finished in 0.1 seconds\n70 examples, 0 failures\n700 / 700 LOC (100.0%) covered."}
    it { is_expected.not_to succeed_with_output "Finished in 0.6 seconds\n70 examples, 0 failures\n384 / 700 LOC (54.86%) covered."}
  end
end
