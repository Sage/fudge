module Fudge
  module Exceptions
    module Cli
      class CommandNotFound < Fudge::Exceptions::Base
        def initialize(command)
          @command = command
        end

        def to_s
          "No command found with name '#{@command}'"
        end
      end

      class CommandNotGiven < Fudge::Exceptions::Base
        def to_s
          "No command given"
        end
      end
    end
  end
end
