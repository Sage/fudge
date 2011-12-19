require 'spec_helper'

module Fudge::Exceptions::Cli
  describe BadUsage do
    it { should be_a Fudge::Exceptions::Base }

    describe :message do
      it "should return the usage string" do
        subject.message.should include "Usage:"

        Fudge::Cli::Commands.constants.each do |task|
          klass = Fudge::Cli::Commands.const_get(task)
          subject.message.should include "#{klass.command}\t#{klass.description}"
        end
      end
    end
  end

  describe CommandNotFound do
    subject { described_class.new :foo }

    it { should be_a Fudge::Exceptions::Cli::BadUsage }

    it "should take a command name as a parameter" do
      expect { described_class.new }.to raise_error ArgumentError
    end
  end

  describe CommandNotGiven do
    it { should be_a Fudge::Exceptions::Cli::BadUsage }
  end
end
