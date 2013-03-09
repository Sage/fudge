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
        # Allow either a string (usually "*") or an array of strings
        # with directories
        redir = @pattern.kind_of?(String) ? Dir[@pattern] : Dir[*@pattern]

        redir.select { |path| File.directory? path }.each do |dir|
          next if exclude && exclude.include?(dir)

          Dir.chdir dir do
            WithDirectory.new(dir).output

            return false unless super
          end
        end
      end

    end

    register EachDirectory
  end
end
