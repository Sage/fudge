require 'spec_helper'

describe Fudge::Description do
  let(:input) { '' }
  let(:file) { StringIO.new(input).tap { |s| allow(s).to receive(:path).and_return('') } }
  subject { described_class.new(file) }

  let(:build) { subject.builds.values.first }
  let(:build_tasks) { build.tasks.dup }

  def make_build
    subject.build :default do
      subject.task :dummy
      yield
    end
    build.callbacks = callbacks
  end

  describe '#initialize' do
    let(:input) { 'build :foo do; end' }

    it 'should add the builds in the given string' do
      expect(subject.builds[:foo]).to be_a Fudge::Build
    end
  end

  describe '#build' do
    it 'should create a new build and add it to the builds array' do
      expect(subject.builds).to be_empty

      subject.build :some_branch do
      end

      expect(subject.builds.size).to eq(1)
      expect(subject.builds[:some_branch]).to be_a Fudge::Build
    end
  end

  describe '#task' do
    it 'should add a task to the current scope' do
      subject.build :default do
        subject.task :dummy
      end

      expect(build_tasks.size).to eq(1)
      expect(build_tasks.first).to be_a DummyTask
    end

    it 'should pass arguments to the initializer' do
      subject.build :default do
        subject.task :dummy, :foo, :bar
      end

      expect(build_tasks.first.args).to eq([:foo, :bar])
    end

    it 'should forward missing methods to task' do
      subject.build :default do
        subject.dummy :foo, :bar
      end

      expect(build_tasks.first.args).to eq([:foo, :bar])
    end

    it 'should super method_missing if no task found' do
      expect { subject.no_task :foo, :bar }.to raise_error(NoMethodError)
    end

    it 'should add tasks recursively to composite tasks' do
      subject.build :default do
        subject.dummy_composite do
          subject.dummy
        end
      end

      expect(build_tasks.first.tasks.first).to be_a DummyTask
    end
  end

  describe '#task_group' do
    it 'should add a task group and allow it to be used in a build' do
      subject.task_group :group1 do
        subject.task :dummy
      end

      subject.build :default do
        subject.task_group :group1
      end

      subject.builds[:default].run
      expect(DummyTask.ran).to be_truthy
    end

    it 'should allow passing arguments to task groups' do
      subject.task_group :special_group do |which|
        subject.task which
      end

      subject.build :default do
        subject.task_group :special_group, :dummy
      end

      subject.builds[:default].run
      expect(DummyTask.ran).to be_truthy
    end

    it 'should raise an exception if task group not found' do
      expect do
        subject.build :default do
          subject.task_group :unkown_group
        end
      end.to raise_error Fudge::Exceptions::TaskGroupNotFound
    end

    context 'grouped tasks' do
      before :each do
        subject.task_group :group1 do
          subject.task :dummy
        end
      end

      it 'allows group task reuse in composite tasks' do
        subject.build :default do
          subject.task :dummy_composite do
            subject.task_group :group1
          end
        end

        subject.builds[:default].run
        expect(DummyTask.ran).to be_truthy
      end

      it 'supports when options are given' do
        subject.build :default do
          subject.task :dummy_composite, :hello, foobar: true do
            subject.task_group :group1
          end
        end

        subject.builds[:default].run

        # Check that the options are maintained through the call
        expect(build_tasks.first.args.size).to eq(2)
        expect(build_tasks.first.args[1][:foobar]).to be_truthy
        expect(DummyTask.ran).to be_truthy
      end
    end
  end

  describe 'Callback Hooks' do
    before :each do
      @ran = []
      allow_any_instance_of(Fudge::Tasks::Shell).to receive(:run_command) do |cmd|
        @ran << cmd.arguments
        ['', cmd.arguments != 'fail']
      end
    end

    describe '#on_success' do
      context 'when callbacks is set to true' do
        let(:callbacks) { true }

        it 'should add success hooks that run after the build is successful' do
          make_build do
            subject.on_success { subject.shell 'FOO' }
            subject.on_success { subject.shell 'BAR' }
          end

          expect(build.run).to be_truthy
          expect(@ran).to eq(%w(FOO BAR))
        end

        it 'fails the build HARD when hooks fail' do
          make_build do
            subject.on_success { subject.shell 'fail'; subject.shell 'FOO' }
            subject.on_success { subject.shell 'BAR' }
          end

          expect(build.run).to be_falsey
          expect(@ran).to eq(['fail'])
        end
      end

      context 'when callbacks is set to false' do
        let(:callbacks) { false }

        it 'should not run the callbacks if the build succeeds' do
          make_build do
            subject.on_success { subject.shell 'echo "WOOP"' }
          end

          expect(build.run).to be_truthy
          expect(@ran).to eq([])
        end
      end
    end

    describe '#on_failure' do
      before :each do
        allow_any_instance_of(DummyTask).to receive(:run).and_return(false)
      end

      context 'when callbacks is set to true' do
        let(:callbacks) { true }

        it 'should add failure hooks that run after the build fails' do
          make_build do
            subject.on_failure { subject.shell 'WOOP' }
            subject.on_failure { subject.shell 'BAR' }
          end

          expect(build.run).to be_falsey
          expect(@ran).to eq(%w(WOOP BAR))
        end

        it 'fails the build HARD when hooks fail' do
          make_build do
            subject.on_failure do
              subject.shell 'fail'
              subject.shell 'FOO'
            end
            subject.on_failure { subject.shell 'BAR' }
          end

          expect(build.run).to be_falsey
          expect(@ran).to eq(['fail'])
        end
      end

      context 'when callbacks is set to false' do
        let(:callbacks) { false }

        it 'should not run the callbacks if the build fails' do
          make_build do
            subject.on_failure { subject.shell 'WOOP' }
          end

          expect(build.run).to be_falsey
          expect(@ran).to eq([])
        end
      end
    end
  end
end
