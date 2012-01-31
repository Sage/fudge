module Fudge
  module Tasks
    # A task which runs a number of other tasks in a given directory (relative to the current directory)
    class EachDirectory < CompositeTask
      def self.name
        :each_directory
      end

      def initialize(pattern, options={})
        super()
        @pattern = pattern
        @options= options
      end

      def run
        Dir[@pattern].select { |path| File.directory? path }.each do |dir|
          next if exclude.include?(dir)

          Dir.chdir dir do
            puts "In directory #{dir}:"
            return false unless super
          end
        end
      end

      private
      def exclude
        @options[:exclude] || []
      end
    end

    register EachDirectory
  end
end
