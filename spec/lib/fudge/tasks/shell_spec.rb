require 'spec_helper'

describe Fudge::Tasks::Shell do
  describe :run do
    it "should take a command and run it" do
      described_class.new(:ls).should run_command 'ls'
    end

    it "should add any arguments given" do
      described_class.new(:ls, '-l', '-a').should run_command 'ls -l -a'
    end

    it "should return true for a successful command" do
      described_class.new(:ls).run.should be_true
    end

    it "should return false for an unsuccessful command" do
      described_class.new(:ls, '--newnre').run.should be_false
    end
  end
end
