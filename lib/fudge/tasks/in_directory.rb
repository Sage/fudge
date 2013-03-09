module Fudge
  module Tasks
    # A task which runs a number of other tasks in a given
    # directory (relative to the current directory)
    class InDirectory < CompositeTask
      def initialize(directory, *args)
        super

        @directory = directory
      end

      def run(options={})
        Dir.chdir @directory do
          WithDirectory.new(@directory).output

          super
        end
      end
    end

    register InDirectory
  end
end
