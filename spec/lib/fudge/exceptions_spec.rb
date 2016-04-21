require 'spec_helper'

module Fudge::Exceptions
  describe Base do
    it { is_expected.to be_a StandardError }
  end

  describe BuildFailed do
    it { is_expected.to be_a Base }

    describe '#message' do
      subject { super().message }
      it { is_expected.to be_a String }
    end
  end

  describe TaskNotFound do
    subject { described_class.new :foo }

    it { is_expected.to be_a Base }

    describe '#message' do
      subject { super().message }
      it { is_expected.to be_a String }
    end

    it 'should take a task name as a parameter' do
      expect { described_class.new }.to raise_error ArgumentError
    end
  end

  describe TaskGroupNotFound do
    subject { described_class.new :foo }

    it { is_expected.to be_a Base }

    describe '#message' do
      subject { super().message }
      it { is_expected.to be_a String }
    end

    it 'should take a task group name as a parameter' do
      expect { described_class.new }.to raise_error ArgumentError
    end
  end
end
