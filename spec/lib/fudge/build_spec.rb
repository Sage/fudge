require 'spec_helper'

describe Fudge::Build do
  it { should be_a Fudge::Tasks::CompositeTask }

  describe "#run" do

    context "when provided an output" do
      let(:stdout) { StringIO.new }
      let(:formatter) { Fudge::Formatters::Simple.new(stdout) }

      it "prints messages to the formatter instead of default" do
        subject.run :formatter => formatter

        stdout.string.should_not be_empty
        stdout.string.should include "Skipping callbacks..."
      end

      context "when there are callback hooks" do
        let(:hook) { double(:Hook) }

        before :each do
          subject.callbacks = true
          subject.success_hooks << hook
        end

        it "passesformatter down to the hook run" do
          hook.should_receive(:run).with(:formatter =>formatter).and_return(true)
          subject.run :formatter => formatter
        end
      end

      context "when the `time` flag is set" do
        before do
          subject.callbacks = true
          allow(subject).to receive(:run_callbacks).and_return(true)
          subject.time = true
        end

        it "should print out the time of the build" do
          expect(subject).to receive(:message) do |message|
            expect(message).to match /Finished in \d+.\d\d seconds./
          end
          subject.run :formatter => formatter
        end
      end
    end
  end
end
