module Fudge
  module Exceptions
    module Cli
      class BadUsage < Fudge::Exceptions::Base
        def message
          usage = "Usage:\n\tfudge <command>\n\nCommands:\n"

          Fudge::Cli::Commands.all.each do |klass|
            usage << "\t#{klass.command}\t#{klass.description}\n"
          end

          usage
        end
      end

      class CommandNotFound < BadUsage
        def initialize(command)
          @command = command
        end

        def message
          "No command found with name '#{@command}'\n" + super
        end
      end

      class CommandNotGiven < BadUsage
        def message
          "No command given\n" + super
        end
      end
    end
  end
end
