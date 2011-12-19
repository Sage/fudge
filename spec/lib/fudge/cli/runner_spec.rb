require 'spec_helper'

describe Fudge::Cli::Runner do
  describe :run do
    it "should run a task with the given name" do
      Fudge::Cli::Commands::Init.any_instance.should_receive(:run)

      subject.run(:init)
    end

    it "should print usage raise an exception if no command is found" do
      expect { subject.run(:blabla) }.to raise_error Fudge::Exceptions::Cli::CommandNotFound
    end

    it "should print usage and raise exception if no command given" do
      expect { subject.run }.to raise_error Fudge::Exceptions::Cli::CommandNotGiven
    end
  end
end
