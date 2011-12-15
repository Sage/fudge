module Fudge
  module Exceptions
    autoload :Cli, 'fudge/exceptions/cli'
    autoload :Build, 'fudge/exceptions/build'

    class Base < StandardError; end
  end
end
