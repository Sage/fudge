module Fudge
  module Exceptions
    module Cli
      # An exception to show that no command was specified on command line
      #
      class CommandNotGiven < StandardError
      end
    end
  end
end
