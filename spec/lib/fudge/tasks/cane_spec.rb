require 'spec_helper'

describe Fudge::Tasks::Cane do
  it { should be_registered_as :cane }

  it_should_behave_like 'bundle aware'

  describe :run do
    it "runs cane on the codebase" do
      subject.should run_command "cane"
    end

    context 'with :doc => false' do
      subject {described_class.new :doc => false }

      it "runs with --no-doc" do
        subject.should run_command "cane --no-doc"
      end
    end

    context 'with :style => false' do
      subject {described_class.new :style => false }

      it "runs with --no-style" do
        subject.should run_command "cane --no-style"
      end
    end

    context 'with :max_width => 100' do
      subject {described_class.new :max_width => 100 }

      it "runs with --style-measure 100" do
        subject.should run_command "cane --style-measure 100"
      end
    end

    it { should_not succeed_with_output 'any output from cane is bad' }
    it { should succeed_with_output '' }
  end
end
