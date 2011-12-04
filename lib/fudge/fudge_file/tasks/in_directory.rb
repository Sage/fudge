require 'fudge/fudge_file/task_registry'
require 'fudge/fudge_file/tasks/composite_task'

module Fudge
  module FudgeFile
    module Tasks
      # A task which runs a number of other tasks in a given directory (relative to the current directory)
      class InDirectory < CompositeTask
        def initialize(directory)
          super()
          @directory = directory
        end

        def run
          FileUtils.chdir @directory do
            super
          end
        end
      end
    end

    TaskRegistry.register(:in_directory, Tasks::InDirectory)
  end
end
