module Fudge
  module Tasks
    # A task which runs a number of other tasks in a given
    # directory (relative to the current directory)
    class InDirectory < CompositeTask
      # Define task name
      def self.name
        :in_directory
      end

      def initialize(directory, *args)
        super
        @directory = directory
      end

      def run(options={})
        Dir.chdir @directory do
          output_dir(@directory)
          super
        end
      end

      private

      def output_dir(dir)
        message = ""
        message << "--> In directory".foreground(:cyan)
        message << " #{dir}:".foreground(:cyan).bright
        puts message
      end
    end

    register InDirectory
  end
end
