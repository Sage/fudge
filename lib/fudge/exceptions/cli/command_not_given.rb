require 'fudge/exceptions/base'

module Fudge
  module Exceptions
    module Cli
      # An exception to show that no command was specified on command line
      #
      class CommandNotGiven < Fudge::Exceptions::Base
        def to_s
          "No command given"
        end
      end
    end
  end
end
