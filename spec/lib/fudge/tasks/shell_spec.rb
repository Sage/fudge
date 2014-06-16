require 'spec_helper'

describe Fudge::Tasks::Shell do
  describe '#run' do
    it "should take a command and run it" do
      expect(described_class.new(:ls)).to run_command 'ls'
    end

    it "should add any arguments given" do
      expect(described_class.new(:ls, '-l', '-a')).to run_command 'ls -l -a'
    end

    it "should return false for an unsuccessful command" do
      expect(described_class.new(:ls, '--newnre').run).to be_falsey
    end

    it "should return true for a successful command" do
      expect(described_class.new(:ls).run).to be_truthy
    end

    context "when there is an formatter passed to run" do

      let(:output) { StringIO.new }
      let(:formatter) { Fudge::Formatters::Simple.new(output) }
      subject { described_class.new('echo foo') }

      it "prints messages to the formatter instead of default" do

        subject.run :formatter => formatter

        expect(output.string).not_to be_empty
        expect(output.string).to include "foo"
      end

      it 'uses the formatter when reporting checks on build result' do
        checker = double.as_null_object
        expect(Fudge::OutputChecker).to receive(:new).with(anything, formatter) { checker }
        subject.run :formatter => formatter
      end

    end
  end

  describe '#check_for' do
    context "with no callable to check the matches" do
      subject { described_class.new(:ls, :check_for => /4 files found/) }

      it { is_expected.to succeed_with_output "Hello there were 4 files found." }
      it { is_expected.not_to succeed_with_output "Hellow there were 5 files found." }
    end

    context "with a callable to check the matches" do
      let(:file_count_matcher) { lambda { |matches| matches[1].to_i >= 4 }}
      subject do
        described_class.new :ls,
          :check_for => [/(\d+) files found/, file_count_matcher]
      end

      it { is_expected.not_to succeed_with_output "Hello there were 3 files found." }
      it { is_expected.to succeed_with_output "Hello there were 4 files found." }
      it { is_expected.to succeed_with_output "Hellow there were 5 files found." }
    end
  end
end
