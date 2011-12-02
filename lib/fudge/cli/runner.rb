require 'fudge/cli/tasks'

module Fudge
  module Cli
    # Parsed command line arguments and runs the specific command
    class Runner
      # Runs a given command
      def run(cmd)
        Fudge::Cli::Tasks.const_get(cmd.capitalize).new.run
      end
    end
  end
end
