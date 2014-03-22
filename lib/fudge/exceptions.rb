module Fudge
  # Errors encountered
  module Exceptions
    # Base class for failures
    class Base < StandardError; end

    # Build failure error class
    class BuildFailed < Base
      # error message
      def message
        "Build FAILED!"
      end
    end

    # Unknown task error class
    class TaskNotFound < Base
      def initialize(task)
        @task = task
      end

      # error message
      def message
        "No task found with name '#{@task}'"
      end
    end

    # Unknown task group error class
    class TaskGroupNotFound < Base
      def initialize(name)
        @name = name
      end

      # error message
      def message
        "No task group found with name '#{@name}'"
      end
    end
  end
end
