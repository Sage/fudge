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
end
