module Fudge
  # Define default tasks
  module Tasks
    # Registers a task under a given name
    def self.register(task_class)
      registered_tasks[task_class.name] = task_class
    end

    # Finds a task with a given name
    def self.discover(name)
      task = registered_tasks[name]
      raise Fudge::Exceptions::TaskNotFound.new(name) unless task
      task
    end

    private
    def self.registered_tasks
      @registered_tasks ||= {}
    end

    # Require all my tasks
    require 'fudge/tasks/task'
    require 'fudge/tasks/shell'
    require 'fudge/tasks/composite_task'
    require 'fudge/tasks/each_directory'
    require 'fudge/tasks/in_directory'
    require 'fudge/tasks/clean_bundler_env'
    require 'fudge/tasks/rake'
    require 'fudge/tasks/rspec'
    require 'fudge/tasks/yard'
    require 'fudge/tasks/cane'
    require 'fudge/tasks/flog'
    require 'fudge/tasks/flay'
  end
end
