module Fudge
  module Cli
    module Commands
      autoload :Init, 'fudge/cli/commands/init'
      autoload :Build, 'fudge/cli/commands/build'

      # All defined command classes
      def self.all
        constants.map do |task|
          const_get(task)
        end
      end

      # Finds a command with a given name
      def self.find(cmd_name)
        cmd = all.detect { |t| t.command == cmd_name }
        raise Fudge::Exceptions::Cli::CommandNotFound.new(cmd_name) unless cmd
        cmd
      end
    end
  end
end
