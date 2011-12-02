require 'spec_helper'
require 'fudge/fudge_file/task'

class TestTask < Fudge::FudgeFile::Task; end

describe Fudge::FudgeFile::Task do
  it { should be_a Thor::Actions }

  describe "Class Methods" do
    subject { described_class }

    describe :register do
      it "should register a task for a given symbol" do
        subject.register(:foo, TestTask)

        subject.discover(:foo).should be_a TestTask
      end
    end

    describe :discover do
      it "should return an instance of the registered class for the given symbol" do
        subject.register(:bar, TestTask)

        subject.discover(:bar).should be_a TestTask
      end

      it "should raise an exception if the task is not found" do
        expect { subject.discover(:something) }.to raise_error Fudge::FudgeFile::Exceptions::TaskNotFound
      end
    end
  end
end
