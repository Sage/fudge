require 'spec_helper'

class TestTask
  def self.name
    :foo
  end
end

describe Fudge::Tasks do
  describe "Class Methods" do
    subject { described_class }

    describe :register do
      it "should register a task for a given symbol" do
        subject.register(TestTask)

        subject.discover(:foo).should == TestTask
      end
    end

    describe :discover do
      it "should return the registered class for the given symbol" do
        subject.register(TestTask)

        subject.discover(:foo).should == TestTask
      end

      it "should raise an exception if the task is not found" do
        no_task_error = Fudge::Exceptions::TaskNotFound
        expect { subject.discover(:something) }.to raise_error no_task_error
      end
    end
  end
end
