require 'spec_helper'
require 'fudge/fudge_file/build'

class DummyTask2 < DummyTask; end
Fudge::FudgeFile::Task.register(:dummy2, DummyTask2)

describe Fudge::FudgeFile::Build do
  describe :task do
    it "should add a task to the tasks array" do
      subject.tasks.should be_empty

      subject.task :dummy

      subject.tasks.should have(1).item
      subject.tasks.first.should be_a DummyTask
    end
  end

  describe :run do
    it "should run all tasks defined" do
      subject.tasks.should be_empty

      DummyTask.any_instance.should_receive(:run)
      DummyTask2.any_instance.should_receive(:run)

      subject.task :dummy
      subject.task :dummy2

      subject.run
    end
  end
end
