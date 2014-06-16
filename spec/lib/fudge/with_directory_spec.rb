require 'spec_helper'

describe Fudge::WithDirectory do
  let(:output) { StringIO.new }
  let(:formatter) { Fudge::Formatters::Simple.new(output) }

  subject { described_class.new '/some/dir', formatter }

  describe "#inside" do
    it "outputs the directory change, yielding the block" do
      expect(Dir).to receive(:chdir).with('/some/dir').and_yield
      subject.inside do
      end

      expect(output.string).to match /In directory.*\/some\/dir/
    end
  end
end
