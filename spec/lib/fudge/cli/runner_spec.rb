require 'spec_helper'
require 'fudge/cli/runner'

describe Fudge::Cli::Runner do
  describe :run do
    it "should run a task with the given name" do
      Fudge::Cli::Tasks::Init.any_instance.should_receive(:run)

      subject.run(:init)
    end

    it "should raise an exception if a task does not exist with the given name" do
    end
  end
end
