module Fudge
  module Tasks
    # A task which runs a number of other tasks in a given directory (relative to the current directory)
    class InDirectory < CompositeTask
      def self.name
        :in_directory
      end

      def initialize(directory, *args)
        super
        @directory = directory
      end

      def run
        Dir.chdir @directory do
          puts "--> In directory".foreground(:red) + " #{@directory}:".foreground(:red).bright
          super
        end
      end
    end

    register InDirectory
  end
end
