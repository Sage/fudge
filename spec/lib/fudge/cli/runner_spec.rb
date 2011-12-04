require 'spec_helper'
require 'fudge/cli/runner'
require 'fudge/exceptions/cli/command_not_found'

describe Fudge::Cli::Runner do
  describe :run do
    it "should run a task with the given name" do
      Fudge::Cli::Commands::Init.any_instance.should_receive(:run)

      subject.run(:init)
    end

    it "should print usage raise an exception if no command is found" do
      subject.should_receive(:usage)

      expect { subject.run(:blabla) }.to raise_error Fudge::Exceptions::Cli::CommandNotFound
    end

    it "should print usage and raise exception if no command given" do
      subject.should_receive(:usage)

      expect { subject.run }.to raise_error Fudge::Exceptions::Cli::CommandNotGiven
    end
  end

  describe :usage do
    it "should print the cli usage" do
      subject.should_receive(:puts) do |content|
        content.should include "Usage:"
      end

      subject.usage
    end

    it "should output all tasks and their description" do
      subject.should_receive(:puts) do |content|
        Fudge::Cli::Commands.constants.each do |task|
          klass = Fudge::Cli::Commands.const_get(task)
          content.should include "#{klass.command}\t#{klass.description}"
        end
      end

      subject.usage
    end
  end
end
