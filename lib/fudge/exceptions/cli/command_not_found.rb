module Fudge
  module Exceptions
    module Cli
      # An exception to show that the command was not found on the command line
      #
      class CommandNotFound < StandardError
      end
    end
  end
end
