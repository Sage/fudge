require 'spec_helper'

describe Fudge::Build do
  it { is_expected.to be_a Fudge::Tasks::CompositeTask }

  describe "#run" do

    context "when provided an output" do
      let(:stdout) { StringIO.new }
      let(:formatter) { Fudge::Formatters::Simple.new(stdout) }

      it "prints messages to the formatter instead of default" do
        subject.run :formatter => formatter

        expect(stdout.string).not_to be_empty
        expect(stdout.string).to include "Skipping callbacks..."
      end

      context "when there are callback hooks" do
        let(:hook) { double(:Hook) }

        before :each do
          subject.callbacks = true
          subject.success_hooks << hook
        end

        it "passesformatter down to the hook run" do
          expect(hook).to receive(:run).with(:formatter =>formatter).and_return(true)
          subject.run :formatter => formatter
        end
      end
    end
  end
end
