require 'spec_helper'

class TestTask;  end

describe Fudge::FudgeFile::TaskRegistry do
  describe "Class Methods" do
    subject { described_class }

    describe :register do
      it "should register a task for a given symbol" do
        subject.register(:foo, TestTask)

        subject.discover(:foo).should == TestTask
      end
    end

    describe :discover do
      it "should return the registered class for the given symbol" do
        subject.register(:bar, TestTask)

        subject.discover(:bar).should == TestTask
      end

      it "should raise an exception if the task is not found" do
        expect { subject.discover(:something) }.to raise_error Fudge::Exceptions::TaskNotFound
      end
    end
  end
end
