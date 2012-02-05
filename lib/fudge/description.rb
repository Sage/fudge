module Fudge
  # A class that represents a FudgeFile definition in Ruby class form.
  #
  class Description
    attr_reader :builds
    attr_accessor :scope

    # Sets builds to an initial empty array
    def initialize(fudge_file_contents)
      @scope = []
      @builds = {}
      @task_groups = {}
      instance_eval(fudge_file_contents, __FILE__, __LINE__)
    end

    # Adds a build to the current description
    def build(name)
      @builds[name] = build = Build.new
      with_scope(build) { yield }
    end

    # Adds a task to the current scope
    def task(name, *args)
      klass = Fudge::Tasks.discover(name)

      task = klass.new(*args)
      current_scope.tasks << [task, args]

      yield if block_given?
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

    # Delegate to the current object scope
    def method_missing(meth, *args, &block)
      task meth, *args, &block
    rescue Fudge::Exceptions::TaskNotFound
      super
    end

    def on_success
      task = Fudge::Tasks::CompositeTask.new
      current_scope.success_hooks << task

      with_scope(task) { yield }
    end

    def on_failure
      task = Fudge::Tasks::CompositeTask.new
      current_scope.failure_hooks << task

      with_scope(task) { yield }
    end

    private
    def current_scope
      scope.last
    end

    def with_scope(task)
      scope << task
      yield
      scope.pop
    end
  end
end
