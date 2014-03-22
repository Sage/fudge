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
        formatter = options[:formatter] || Fudge::Formatters::Simple.new
        directories.all? do |dir|
          skip_directory?(dir) ||
            WithDirectory.new(dir, formatter).inside do
              super
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
