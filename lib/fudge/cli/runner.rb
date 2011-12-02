require 'fudge/cli/commands'

module Fudge
  module Cli
    # Parsed command line arguments and runs the specific command
    class Runner
      # Runs a given command
      def run(*args)
        return usage if args.empty?

        command = find_command(args.first)
        return usage_and_die! unless command

        command.new.run
      end

      # Prints usage to stdout
      def usage
        usage = <<-TEXT
Usage:
\tfudge <task>

Tasks:
TEXT

        commands.each do |klass|
          usage << "\t#{klass.command}\t#{klass.description}"
        end

        puts usage
      end

      private
      # Exits with a non-zero exit status
      def die!
        exit(1)
      end

      # Prints usage and dies
      def usage_and_die!
        usage
        die!
      end

      # All defined command classes
      def commands
        Fudge::Cli::Commands.constants.map do |task|
          Fudge::Cli::Commands.const_get(task)
        end
      end

      # Finds a command with a given name
      def find_command(cmd)
        commands.detect { |t| t.command == cmd }
      end
    end
  end
end
