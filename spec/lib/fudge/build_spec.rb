require 'spec_helper'

describe Fudge::Build do
  it { should be_a Fudge::Tasks::CompositeTask }

  describe "#run" do

    context "when provided an output" do
      let(:output) { StringIO.new }

      it "prints messages to the output instead of stdout" do
        subject.run :output => output

        output.string.should_not be_empty
        output.string.should include "Skipping callbacks..."
      end

      context "when there are callback hooks" do
        let(:hook) { double(:Hook) }

        before :each do
          subject.callbacks = true
          subject.success_hooks << hook
        end

        it "passes output down to the hook run" do
          hook.should_receive(:run).with(:output => output).and_return(true)
          subject.run :output => output
        end
      end
    end
  end
end
