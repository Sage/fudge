module Fudge
  module Exceptions
    module Build
      class BuildFailed < Fudge::Exceptions::Base
        def message
          "Build FAILED!".foreground(:red).bright
        end
      end

      class TaskNotFound < Fudge::Exceptions::Base
        def initialize(task)
          @task = task
        end

        def message
          "No task found with name '#{@task}'"
        end
      end
    end
  end
end
