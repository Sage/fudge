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

  describe "Class Methods" do
    describe :task do
      class AnotherCompositeTask < Fudge::Tasks::CompositeTask
        task :shell, 'foo', 'bar'
      end

      subject { AnotherCompositeTask.new }

      it "should define a task for each new instance of the composite task" do
        subject.should run_command 'foo bar'
      end
    end
  end
end
