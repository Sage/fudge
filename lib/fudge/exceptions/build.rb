module Fudge
  module Exceptions
    module Build
      class BuildFailed < Fudge::Exceptions::Base
        def to_s
          "Build failed"
        end
      end

      class TaskNotFound < Fudge::Exceptions::Base
        def initialize(task)
          @task = task
        end

        def to_s
          "No task found with name '#{@task}'"
        end
      end
    end
  end
end
