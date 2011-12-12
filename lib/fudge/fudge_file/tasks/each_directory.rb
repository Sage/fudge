require 'fudge/fudge_file/tasks/composite_task'

module Fudge
  module FudgeFile
    module Tasks
      # A task which runs a number of other tasks in a given directory (relative to the current directory)
      class EachDirectory < CompositeTask
        def self.name
          :each_directory
        end

        def initialize(pattern)
          super()
          @pattern = pattern
        end

        def run
          Dir[@pattern].select { |path| File.directory? path }.each do |dir|
            Dir.chdir dir do
              puts "In directory #{dir}:"
              return false unless super
            end
          end
        end
      end

      TaskRegistry.register(EachDirectory)
    end
  end
end
