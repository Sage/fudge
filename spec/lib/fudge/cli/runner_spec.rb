require 'spec_helper'
require 'fudge/cli/runner'

describe Fudge::Cli::Runner do
  describe :run do
    it "should run a task with the given name" do
      Fudge::Cli::Commands::Init.any_instance.should_receive(:run)

      subject.run(:init)
    end

    it "should print usage and die if no task is found" do
      subject.should_receive(:usage)
      subject.should_receive(:exit) do |code|
        code.should_not == 0
      end

      subject.run(:blabla)
    end

    it "should print usage if no command given" do
      subject.should_receive(:usage)

      subject.run
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
