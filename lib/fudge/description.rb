module Fudge
  # A class that represents a FudgeFile definition in Ruby class form.
  #
  class Description
    include TaskDSL

    attr_reader :builds

    # Sets builds to an initial empty array
    def initialize(file)
      @path = file.path
      @builds = {}
      @task_groups = {}
      instance_eval(file.read, __FILE__, __LINE__)
    end

    # Adds a build to the current description
    def build(name)
      @builds[name] = build = Build.new
      with_scope(build) { yield }
    end

    # Adds a task group to the current description or includes a task group
    def task_group(name, *args, &block)
      if block
        @task_groups[name] = block
      else
        find_task_group(name).call(*args)
      end
    end

    # Gets a task group of the given name
    def find_task_group(name)
      @task_groups[name].tap do |block|
        raise Exceptions::TaskGroupNotFound.new(name) unless block
      end
    end

    # Add actions to be invoked upon success
    def on_success
      task = Fudge::Tasks::CompositeTask.new
      current_scope.success_hooks << task

      with_scope(task) { yield }
    end

    # Add actions to be invoked upon failure
    def on_failure
      task = Fudge::Tasks::CompositeTask.new
      current_scope.failure_hooks << task

      with_scope(task) { yield }
    end
  end
end
