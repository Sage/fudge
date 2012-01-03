require 'spec_helper'

module Fudge::Exceptions
  describe Base do
    it { should be_a StandardError }
  end

  describe BuildFailed do
    it { should be_a Base }
  end

  describe TaskNotFound do
    subject { described_class.new :foo }

    it { should be_a Base }

    it "should take a task name as a parameter" do
      expect { described_class.new }.to raise_error ArgumentError
    end
  end
end
