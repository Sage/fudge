require 'spec_helper'

class DummyTask2 < DummyTask
  def self.name
    :dummy2
  end
end
Fudge::Tasks.register(DummyTask2)

describe Fudge::Tasks::CompositeTask do
  subject { described_class.new do; end }

  describe :run do
    before :each do
      subject.tasks << DummyTask.new
      subject.tasks << DummyTask2.new
    end

    it "should run all tasks defined and return true if they all succeed" do
      DummyTask.any_instance.should_receive(:run).and_return(true)
      DummyTask2.any_instance.should_receive(:run).and_return(true)

      subject.run.should be_true
    end

    it "should return false if any of the tasks fail" do
      DummyTask.any_instance.should_receive(:run).and_return(false)
      DummyTask2.any_instance.should_not_receive(:run)

      subject.run.should be_false
    end
  end

  describe "Using TaskDSL" do
    describe :task do
      class AnotherCompositeTask < Fudge::Tasks::CompositeTask
        include Fudge::TaskDSL

        def initialize(*args)
          super

          task :shell, 'foo', 'bar'
          task :dummy_composite do
            task :dummy
          end
        end
      end

      subject { AnotherCompositeTask.new }

      it "should define a task for each new instance of the composite task" do
        subject.should run_command 'foo bar'
      end

      it "should support defining composite tasks" do
        subject.tasks[1].tasks.first.should be_a DummyTask
      end

      context "when provided an output" do
        let(:output) { StringIO.new }

        before :each do
          Fudge::Tasks::Shell.any_instance.stub(:run)
        end

        it "prints messages to the output instead of stdout" do
          subject.run :output => output

          output.string.should_not be_empty
          output.string.should match /Running task.*shell.*foo, bar/
        end
      end
    end
  end
end
