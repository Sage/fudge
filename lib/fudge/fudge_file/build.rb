require 'fudge/fudge_file/tasks'

module Fudge
  module FudgeFile
    # Represents a build defined in the FudgeFile
    #
    class Build
      attr_reader :tasks

      # Sets the tasks to an initial empty array
      def initialize
        @tasks = []
      end

      # Adds a task to the build
      def task(task_type, *args)
        @tasks << Tasks.discover(task_type).new(*args)
      end

      # Runs a build
      def run
        @tasks.each(&:run)
      end
    end
  end
end
