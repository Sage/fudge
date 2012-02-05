require 'spec_helper'

describe Fudge::Build do
  let(:desc) { Fudge::Description.new '' }
  it { should be_a Fudge::Tasks::CompositeTask }

  describe "Callback Hooks" do
    before :each do
      @ran = []
      Fudge::Tasks::Shell.any_instance.stub(:run_command) do |cmd|
        @ran << cmd
        ['', cmd != 'fail']
      end
    end

    describe :on_success do
      context "when callbacks is set to true" do
        subject { described_class.new :callbacks => true, :description => desc }

        it "should add success hooks that run after the build is successful" do
          subject.on_success { subject.shell 'echo "WOOP"' }
          subject.on_success { subject.shell 'echo "BAR"' }

          subject.run.should be_true
          @ran.should == ['echo "WOOP"', 'echo "BAR"']
        end

        it "should fail the build and stop running callbacks if any of the success hooks fail" do
          subject.on_success { subject.shell 'fail'; subject.shell 'echo "FOO"' }
          subject.on_success { subject.shell 'echo "BAR"' }

          subject.run.should be_false
          @ran.should == ['fail']
        end
      end

      context "when callbacks is set to false" do
        subject { described_class.new :callbacks => false, :description => desc }

        it "should not run the callbacks if the build succeeds" do
          subject.on_success { subject.shell 'echo "WOOP"' }

          subject.run.should be_true
          @ran.should == []
        end
      end
    end

    describe :on_failure do
      before :each do
        subject.task :dummy
        DummyTask.any_instance.stub(:run).and_return(false)
      end

      context "when callbacks is set to true" do
        subject { described_class.new :callbacks => true }

        it "should add failure hooks that run after the build fails" do
          subject.on_failure { subject.shell 'echo "WOOP"' }
          subject.on_failure { subject.shell 'echo "BAR"' }

          subject.run.should be_false
          @ran.should == ['echo "WOOP"', 'echo "BAR"']
        end

        it "should fail the build and stop running callbacks if any of the failure hooks fail" do
          subject.on_failure { subject.shell 'fail'; subject.shell 'echo "FOO"' }
          subject.on_failure { subject.shell 'echo "BAR"' }

          subject.run.should be_false
          @ran.should == ['fail']
        end
      end

      context "when callbacks is set to false" do
        subject { described_class.new :callbacks => false }

        it "should not run the callbacks if the build fails" do
          subject.on_failure { subject.shell 'echo "WOOP"' }

          subject.run.should be_false
          @ran.should == []
        end
      end
    end
  end
end
