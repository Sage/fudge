require 'spec_helper'

describe Fudge::OutputChecker do
  let(:output_io) { StringIO.new }
  let(:formatter) { Fudge::Formatters::Simple.new(output_io) }

  describe '#check' do
    subject { described_class.new(/foo/, formatter) }

    context 'when the output does not match the check' do
      it 'send a mismatch message to the output io' do
        subject.check('bar')
        expect(output_io.string).to include "Output didn't match (?-mix:foo)."
      end
    end

    context 'with a block for checking' do
      let(:callable) do
        proc do
          false
        end
      end
      subject { described_class.new [/foo/, callable], formatter }

      it 'sends error mesage to the output io' do
        subject.check('foo')

        expect(output_io.string).to include 'Output matched (?-mix:foo) but condition failed.'
      end
    end
  end
end
