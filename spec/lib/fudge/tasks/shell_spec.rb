require 'spec_helper'

describe Fudge::Tasks::Shell do
  describe :run do
    it "should take a command and run it" do
      described_class.new(:ls).should run_command 'ls'
    end

    it "should add any arguments given" do
      described_class.new(:ls, '-l', '-a').should run_command 'ls -l -a'
    end

    it "should return false for an unsuccessful command" do
      described_class.new(:ls, '--newnre').run.should be_false
    end

    it "should return true for a successful command" do
      described_class.new(:ls).run.should be_true
    end

    context "when there is an output passed to run" do

      let(:output) { StringIO.new }
      subject { described_class.new('echo foo') }

      it "prints messages to the output instead of stdout" do

        subject.run :output => output

        output.string.should_not be_empty
        output.string.should include "foo"
      end

      it 'uses the output stream when reporting checks on build result' do
        checker = stub.as_null_object
        Fudge::OutputChecker.should_receive(:new).with(anything, output) { checker }
        subject.run :output => output
      end

    end
  end

  describe :check_for do
    context "with no callable to check the matches" do
      subject { described_class.new(:ls, :check_for => /4 files found/) }

      it { should succeed_with_output "Hello there were 4 files found." }
      it { should_not succeed_with_output "Hellow there were 5 files found." }
    end

    context "with a callable to check the matches" do
      let(:file_count_matcher) { lambda { |matches| matches[1].to_i >= 4 }}
      subject do
        described_class.new :ls,
          :check_for => [/(\d+) files found/, file_count_matcher]
      end

      it { should_not succeed_with_output "Hello there were 3 files found." }
      it { should succeed_with_output "Hello there were 4 files found." }
      it { should succeed_with_output "Hellow there were 5 files found." }
    end
  end
end
