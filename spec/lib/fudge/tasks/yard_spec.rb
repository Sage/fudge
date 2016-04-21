require 'spec_helper'

describe Fudge::Tasks::Yard do
  subject { described_class.new }

  it { is_expected.to be_registered_as :yard }

  describe '#run' do
    it 'runs stats with undocumented by default' do
      expect(subject).to run_command 'yard stats --list-undoc'
    end

    it 'should run yard with any arguments passed in' do
      task = described_class.new('-r YardREADME.md')
      expect(task).to run_command 'yard -r YardREADME.md'
    end
  end

  it_should_behave_like 'bundle aware'

  describe '#coverage' do
    subject { described_class.new coverage: 99 }

    it { is_expected.not_to succeed_with_output 'some dummy output with no coverage' }
    it { is_expected.not_to succeed_with_output '98.99999% documented' }
    it { is_expected.not_to succeed_with_output '0.00% documented' }
    it { is_expected.to succeed_with_output '99.99999% documented' }
    it { is_expected.to succeed_with_output '100.0% documented' }
  end
end
