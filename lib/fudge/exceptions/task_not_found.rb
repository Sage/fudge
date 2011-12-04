require 'fudge/exceptions/base'

module Fudge
  module Exceptions
    # An exception to show that a task was not found
    #
    class TaskNotFound < Base
      def initialize(task)
        @task = task
      end

      def to_s
        "No task found with name '#{@task}'"
      end
    end
  end
end
