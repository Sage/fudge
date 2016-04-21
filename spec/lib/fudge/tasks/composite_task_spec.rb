require 'spec_helper'

class DummyTask2 < DummyTask
  def self.name
    :dummy2
  end
end
Fudge::Tasks.register(DummyTask2)

describe Fudge::Tasks::CompositeTask do
  subject { described_class.new { ; } }

  describe '#run' do
    before :each do
      subject.tasks << DummyTask.new
      subject.tasks << DummyTask2.new

      @task_two_run = false
      allow_any_instance_of(DummyTask2).to receive(:run) { |*_| @task_two_run = true }
    end

    it 'should run all tasks defined and return true if they all succeed' do
      expect_any_instance_of(DummyTask).to receive(:run).and_return(true)
      expect(subject.run).to be_truthy
      expect(@task_two_run).to be_truthy
    end

    it 'should return false if any of the tasks fail' do
      expect_any_instance_of(DummyTask).to receive(:run).and_return(false)
      expect(subject.run).to be_falsey
      expect(@task_two_run).to be_falsey
    end
  end

  describe 'Using TaskDSL' do
    describe '#task' do
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

      it 'should define a task for each new instance of the composite task' do
        expect(subject).to run_command 'foo bar'
      end

      it 'should support defining composite tasks' do
        expect(subject.tasks[1].tasks.first).to be_a DummyTask
      end

      context 'when provided an output' do
        let(:output) { StringIO.new }
        let(:formatter) { Fudge::Formatters::Simple.new(output) }

        before :each do
          allow_any_instance_of(Fudge::Tasks::Shell).to receive(:run)
        end

        it 'prints messages to the output instead of stdout' do
          subject.run formatter: formatter

          expect(output.string).not_to be_empty
          expect(output.string).to match /Running task.*shell.*foo, bar/
        end
      end
    end
  end
end
