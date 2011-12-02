require 'fudge/fudge_file/task'

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
      def task(task_type)
        @tasks << Task.discover(task_type)
      end

      # Runs a build
      def run
        @tasks.each do |t|
          t.run
        end
      end
    end
  end
end
