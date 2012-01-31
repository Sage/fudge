require 'spec_helper'

class DummyTask2 < DummyTask
  attr_accessor :args

  def self.name
    :dummy2
  end
  def initialize(*args)
    self.args = args
  end
end
Fudge::Tasks.register(DummyTask2)

describe Fudge::Tasks::CompositeTask do
  subject { described_class.new do; end }

  describe :initialize do
    it "should yield itself" do
      build = nil
      described_class.new do |b|
        build = b
      end

      build.should be_a Fudge::Tasks::CompositeTask
    end
  end

  describe :task do
    it "should add a task to the tasks array" do
      subject.tasks.should be_empty

      subject.task :dummy

      subject.tasks.should have(1).item
      subject.tasks.first.should be_a DummyTask
    end

    it "should pass arguments to the initializer" do
      subject.tasks.should be_empty

      subject.task :dummy2, :foo, :bar

      subject.tasks.first.args.should == [:foo, :bar]
    end

    it "should forward missing methods to task" do
      subject.tasks.should be_empty

      subject.dummy2 :foo, :bar

      subject.tasks.first.args.should == [:foo, :bar]
    end
  end

  describe :run do
    it "should run all tasks defineid and return true if they all succeed" do
      subject.tasks.should be_empty

      DummyTask.any_instance.should_receive(:run).and_return(true)
      DummyTask2.any_instance.should_receive(:run).and_return(true)

      subject.task :dummy
      subject.task :dummy2

      subject.run.should be_true
    end

    it "should return false if any of the tasks fail" do
      subject.tasks.should be_empty

      DummyTask.any_instance.should_receive(:run).and_return(false)
      DummyTask2.any_instance.should_not_receive(:run)

      subject.task :dummy
      subject.task :dummy2

      subject.run.should be_false
    end
  end
end
