module Fudge
  # A class that represents a FudgeFile definition in Ruby class form.
  #
  class Description
    attr_reader :builds

    # Sets builds to an initial empty array
    def initialize(fudge_file_contents)
      @builds = {}
      @task_groups = {}
      eval(fudge_file_contents)
    end

    # Adds a build to the current description
    def build(name, &block)
      @builds[name] = Build.new(self, &block)
    end

    # Adds a task group to the current description
    def task_group(name, &block)
      @task_groups[name] = block
    end

    # Gets a task group of the given name
    def find_task_group(name)
      @task_groups[name].tap do |block|
        raise Exceptions::TaskGroupNotFound.new(name) unless block
      end
    end
  end
end
