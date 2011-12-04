require 'fudge/cli/commands'
require 'fudge/exceptions/cli/command_not_given'
require 'fudge/exceptions/cli/command_not_found'

module Fudge
  module Cli
    # Parsed command line arguments and runs the specific command
    class Runner
      # Runs a given command
      def run(*args)
        usage_and_raise Fudge::Exceptions::Cli::CommandNotGiven if args.empty?

        command_name = args.first
        command = find_command(command_name)
        usage_and_raise Fudge::Exceptions::Cli::CommandNotFound.new(command_name) unless command

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
          usage << "\t#{klass.command}\t#{klass.description}\n"
        end

        puts usage
      end

      private
      # Prints usage and raises given exception
      def usage_and_raise(exception)
        usage
        raise exception
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
