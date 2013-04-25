require 'spec_helper'

describe Fudge::OutputChecker do
  let (:output_io) { StringIO.new }

  describe "#check" do
    subject { described_class.new /foo/, output_io }

    context "when the output does not match the check" do
       it 'send a mismatch message to the output io' do
          subject.check('bar')
          output_io.string.should include "Output didn't match (?-mix:foo)."
       end
    end

    context "with a block for checking" do
      let(:callable) do
        Proc.new do
          false
        end
      end
      subject { described_class.new [/foo/, callable], output_io }

      it 'sends error mesage to the output io' do
        subject.check('foo')

        output_io.string.should include "Output matched (?-mix:foo) but condition failed."
      end
    end
  end
end
