module Fudge
  module Tasks
    # A task which runs a number of other tasks in a given directory
    # (relative to the current directory)
    class EachDirectory < CompositeTask
      attr_accessor :exclude

      def initialize(pattern, *args)
        super(*args)

        @pattern = pattern
      end

      def run(options={})
        directories.each do |dir|
          next if skip_directory?(dir)
          WithDirectory.new(dir).inside do
            return false unless super
          end
        end
      end

      private

      def directories
        # Allow either a string (usually "*") or an array of strings
        # with directories
        files = @pattern.kind_of?(String) ? Dir[@pattern] : Dir[*@pattern]
        files.select { |path| File.directory? path }
      end

      def skip_directory?(dir)
        exclude && exclude.include?(dir)
      end

    end

    register EachDirectory
  end
end
