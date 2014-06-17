module Fudge
  module Tasks
    # A task which runs a number of other tasks in a given
    # directory (relative to the current directory)
    class InDirectory < CompositeTask
      def initialize(directory, *args)
        super

        @directory = directory
      end

      # Run task
      def run(options={})
        formatter = get_formatter(options)
        WithDirectory.new(@directory, formatter).inside do
          super
        end
      end
    end

    register InDirectory
  end
end
