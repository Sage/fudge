require 'spec_helper'

describe Fudge::Description do
  subject { described_class.new '' }

  describe :initialize do
    it "should add the builds in the given string" do
      desc = described_class.new "build :foo do; end"

      desc.builds[:foo].should be_a Fudge::Build
    end
  end

  describe :build do
    it "should create a new build and add it to the builds array" do
      subject.builds.should be_empty

      subject.build :some_branch do
      end

      subject.builds.should have(1).item
      subject.builds[:some_branch].should be_a Fudge::Build
    end

    it "should pass the block to the build object" do
      build = nil
      subject.build :default do |b|
        build = b
      end

      subject.builds[:default].should == build
    end
  end

  describe :task_group do
    it "should add a task group and allow it to be used in a build" do
      subject.task_group :group1 do
        task :dummy
      end

      subject.build :default do
        task_group :group1
      end

      subject.builds[:default].run

      DummyTask.ran.should be_true
    end

    it "should raise an exception if task group not found" do
      expect do
        subject.build :default do
          task_group :unkown_group
        end
      end.to raise_error Fudge::Exceptions::TaskGroupNotFound
    end
  end

  it "should allow the use of task groups through nested layers of composite tasks" do
    subject.task_group :group1 do
      task :dummy
    end

    subject.build :default do
      task :dummy_composite do
        task_group :group1
      end
    end

    subject.builds[:default].run

    DummyTask.ran.should be_true
  end

  it "should allow the use of task grouops through nested layers of composite nodes when options are given" do
    subject.task_group :group1 do
      task :dummy
    end

    subject.build :default do
      task :dummy_composite, :hello, :foobar => true do
        task_group :group1
      end
    end

    subject.builds[:default].run

    # Check that the options are maintained through the call
    subject.builds[:default].tasks.first[0].args.should have(2).items
    subject.builds[:default].tasks.first[0].args[1][:foobar].should be_true
    DummyTask.ran.should be_true
  end
end
