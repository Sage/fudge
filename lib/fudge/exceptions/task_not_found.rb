module Fudge
  module Exceptions
    # An exception to show that a task was not found
    #
    class TaskNotFound < StandardError
      def initialize(task)
        @task = task
      end

      def to_s
        "No task found with name '#{@task}'"
      end
    end
  end
end
