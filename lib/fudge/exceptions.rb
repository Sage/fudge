module Fudge
  module Exceptions
    class Base < StandardError; end

    class BuildFailed < Base
      def message
        "Build FAILED!".foreground(:red).bright
      end
    end

    class TaskNotFound < Base
      def initialize(task)
        @task = task
      end

      def message
        "No task found with name '#{@task}'"
      end
    end
  end
end
