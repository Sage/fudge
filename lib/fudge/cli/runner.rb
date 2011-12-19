module Fudge
  module Cli
    # Parsed command line arguments and runs the specific command
    class Runner
      # Runs a given command
      def run(*args)
        raise Fudge::Exceptions::Cli::CommandNotGiven if args.empty?

        command = Commands.find(args.first.to_sym)

        command.new.run
      end
    end
  end
end
