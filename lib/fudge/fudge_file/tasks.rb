require 'thor/actions'
require 'fudge/exceptions/task_not_found'

module Fudge
  module FudgeFile
    # A class representing a task to run
    #
    class Tasks
      # Class methods
      class << self
        # Registers a task under a given name
        def register(name, task_class)
          registered_tasks[name] = task_class
        end

        # Finds a task with a given name
        def discover(name)
          task = registered_tasks[name]
          raise Fudge::Exceptions::TaskNotFound.new(name) unless task
          task
        end

        private
        def registered_tasks
          @registered_tasks ||= {}
        end
      end
    end
  end
end
