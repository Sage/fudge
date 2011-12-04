require 'fudge/fudge_file/task_registry'

module Fudge
  module FudgeFile
    module Tasks
      class CompositeTask
        attr_reader :tasks

        # Sets the tasks to an initial empty array
        def initialize
          @tasks = []
          yield self if block_given?
        end

        # Adds a task to this task as a child
        def task(task_type, *args)
          @tasks << Fudge::FudgeFile::TaskRegistry.discover(task_type).new(*args)
        end

        # Runs the task (by default running all other tasks in order)
        def run
          @tasks.each do |t|
            return unless t.run
          end
        end
      end
    end
  end
end
