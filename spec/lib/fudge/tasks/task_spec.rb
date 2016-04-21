require 'spec_helper'

class MyTask < Fudge::Tasks::Task
  attr_accessor :cod

  attr_accessor :_methods_missing
  def method_missing(method, *_args)
    (@_methods_missing ||= []).push(method)
  end
end

class TestNamespace
  class SomeTask < Fudge::Tasks::Task
  end
end

describe Fudge::Tasks::Task do
  describe :initialize do
    context 'given arguments' do
      it 'accepts and stores the arguments' do
        task = MyTask.new :foo, :bar, :baz
        expect(task.args).to match_array [:foo, :bar, :baz]
      end
    end

    context 'given options' do
      let (:task) { MyTask.new cod: 'fanglers' }

      it 'accepts and sets the options' do
        expect(task.cod).to eq 'fanglers'
      end

      it 'accepts and stores the options' do
        expect(task.options).to eq(cod: 'fanglers')
      end

      context 'including an option that is not supported' do
        let (:task) { MyTask.new cod: 'fanglers', foo: 'bar' }

        it 'ignores the unsupported options' do
          expect(task._methods_missing).to be_nil
        end

        it 'stores all provided options' do
          expect(task.options).to eq(cod: 'fanglers', foo: 'bar')
        end
      end
    end

    context 'given arguments and options' do
      let (:task) { MyTask.new :foo, :bar, cod: 'fanglers' }

      it 'stores the arguments separately from the options' do
        expect(task.args).to match_array [:foo, :bar]
      end

      it 'applies the options' do
        expect(task.cod).to eq 'fanglers'
      end

      it 'stores the options separately from the arguments' do
        expect(task.options).to eq(cod: 'fanglers')
      end
    end
  end

  describe :name do
    it 'should default to implied name from class name' do
      expect(TestNamespace::SomeTask.name).to eq(:some_task)
    end
  end
end
