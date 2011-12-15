module Fudge
  module FudgeFile
    # A class representing a task to run
    #
    class TaskRegistry
      # Class methods
      class << self
        # Registers a task under a given name
        def register(task_class)
          registered_tasks[task_class.name] = task_class
        end

        # Finds a task with a given name
        def discover(name)
          task = registered_tasks[name]
          raise Fudge::Exceptions::Build::TaskNotFound.new(name) unless task
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
