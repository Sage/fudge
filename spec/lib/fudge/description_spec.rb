require 'spec_helper'

describe Fudge::Description do
  let(:build) { subject.builds.values.first }
  let(:build_tasks) { build.tasks.map }

  def make_build
    subject.build :default do
      subject.task :dummy
      yield
    end
    build.callbacks = callbacks
  end

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
  end

  describe :task do
    it "should add a task to the current scope" do
      subject.build :default do
        subject.task :dummy
      end

      build_tasks.should have(1).item
      build_tasks.first.should be_a DummyTask
    end

    it "should pass arguments to the initializer" do
      subject.build :default do
        subject.task :dummy, :foo, :bar
      end

      build_tasks.first.args.should == [:foo, :bar]
    end

    it "should forward missing methods to task" do
      subject.build :default do
        subject.dummy :foo, :bar
      end

      build_tasks.first.args.should == [:foo, :bar]
    end

    it "should super method_missing if no task found" do
      expect { subject.non_existeng_task :foo, :bar }.to raise_error(NoMethodError)
    end

    it "should add tasks recursively to composite tasks" do
      subject.build :default do
        subject.dummy_composite do
          subject.dummy
        end
      end

      build_tasks.first.tasks.first.should be_a DummyTask
    end
  end

  describe :task_group do
    it "should add a task group and allow it to be used in a build" do
      subject.task_group :group1 do
        subject.task :dummy
      end

      subject.build :default do
        subject.task_group :group1
      end

      subject.builds[:default].run
      DummyTask.ran.should be_true
    end

    it "should allow passing arguments to task groups" do
      subject.task_group :special_group do |which|
        subject.task which
      end

      subject.build :default do
        subject.task_group :special_group, :dummy
      end

      subject.builds[:default].run
      DummyTask.ran.should be_true
    end

    it "should raise an exception if task group not found" do
      expect do
        subject.build :default do
          subject.task_group :unkown_group
        end
      end.to raise_error Fudge::Exceptions::TaskGroupNotFound
    end

    it "should allow the use of task groups through nested layers of composite tasks" do
      subject.task_group :group1 do
        subject.task :dummy
      end

      subject.build :default do
        subject.task :dummy_composite do
          subject.task_group :group1
        end
      end

      subject.builds[:default].run
      DummyTask.ran.should be_true
    end

    it "should allow the use of task groups through nested layers of composite nodes when options are given" do
      subject.task_group :group1 do
        subject.task :dummy
      end

      subject.build :default do
        subject.task :dummy_composite, :hello, :foobar => true do
          subject.task_group :group1
        end
      end

      subject.builds[:default].run

      # Check that the options are maintained through the call
      build_tasks.first.args.should have(2).items
      build_tasks.first.args[1][:foobar].should be_true
      DummyTask.ran.should be_true
    end
  end

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
        let(:callbacks) { true }

        it "should add success hooks that run after the build is successful" do
          make_build do
            subject.on_success { subject.shell 'FOO' }
            subject.on_success { subject.shell 'BAR' }
          end

          build.run.should be_true
          @ran.should == ['FOO', 'BAR']
        end

        it "should fail the build and stop running callbacks if any of the success hooks fail" do
          make_build do
            subject.on_success { subject.shell 'fail'; subject.shell 'FOO' }
            subject.on_success { subject.shell 'BAR' }
          end

          build.run.should be_false
          @ran.should == ['fail']
        end
      end

      context "when callbacks is set to false" do
        let(:callbacks) { false }

        it "should not run the callbacks if the build succeeds" do
          make_build do
            subject.on_success { subject.shell 'echo "WOOP"' }
          end

          build.run.should be_true
          @ran.should == []
        end
      end
    end

    describe :on_failure do
      before :each do
        DummyTask.any_instance.stub(:run).and_return(false)
      end

      context "when callbacks is set to true" do
        let(:callbacks) { true }

        it "should add failure hooks that run after the build fails" do
          make_build do
            subject.on_failure { subject.shell 'WOOP' }
            subject.on_failure { subject.shell 'BAR' }
          end

          build.run.should be_false
          @ran.should == ['WOOP', 'BAR']
        end

        it "should fail the build and stop running callbacks if any of the failure hooks fail" do
          make_build do
            subject.on_failure { subject.shell 'fail'; subject.shell 'FOO' }
            subject.on_failure { subject.shell 'BAR' }
          end

          build.run.should be_false
          @ran.should == ['fail']
        end
      end

      context "when callbacks is set to false" do
        let(:callbacks) { false }

        it "should not run the callbacks if the build fails" do
          make_build do
            subject.on_failure { subject.shell 'WOOP' }
          end

          build.run.should be_false
          @ran.should == []
        end
      end
    end
  end
end
