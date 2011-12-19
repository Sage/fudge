require 'spec_helper'

module Fudge::Exceptions::Build

  describe BuildFailed do
    it { should be_a Fudge::Exceptions::Base }
  end

  describe TaskNotFound do
    subject { described_class.new :foo }

    it { should be_a Fudge::Exceptions::Base }

    it "should take a task name as a parameter" do
      expect { described_class.new }.to raise_error ArgumentError
    end
  end

end
