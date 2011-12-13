require 'fudge/exceptions/base'

module Fudge
  module Exceptions
    # An exception to show that a task was not found
    #
    class BuildFailed < Base
      def to_s
        "Build failed"
      end
    end
  end
end
