module Fudge
  module Tasks
    # A task which runs a number of other tasks in a given directory (relative to the current directory)
    class EachDirectory < CompositeTask
      attr_accessor :exclude

      def self.name
        :each_directory
      end

      def initialize(pattern, *args)
        super

        @pattern = pattern
      end

      def run
        Dir[@pattern].select { |path| File.directory? path }.each do |dir|
          next if exclude && exclude.include?(dir)

          Dir.chdir dir do
            puts "In directory #{dir}:"
            return false unless super
          end
        end
      end
    end

    register EachDirectory
  end
end
