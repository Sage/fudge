require 'spec_helper'

describe Fudge::WithDirectory do
  let(:output) { StringIO.new }

  subject { described_class.new '/some/dir', output }

  describe "#inside" do
    it "outputs the directory change, yielding the block" do
      Dir.should_receive(:chdir).with('/some/dir').and_yield
      subject.inside do
      end

      output.string.should match /In directory.*\/some\/dir/
    end
  end
end
