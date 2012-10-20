require 'spec_helper'

describe Fudge::Tasks::Cane do
  it { should be_registered_as :cane }

  it_should_behave_like 'bundle aware'

  describe :run do
    it "runs cane on the codebase" do
      subject.should run_command "cane"
    end

    it { should_not succeed_with_output 'any output from cane is bad' }
    it { should succeed_with_output '' }
  end
end
