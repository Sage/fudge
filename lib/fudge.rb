require 'rainbow'
require 'active_support/core_ext/array'

module Fudge
  autoload :Build, 'fudge/build'
  autoload :Cli, 'fudge/cli'
  autoload :Description, 'fudge/description'
  autoload :Exceptions, 'fudge/exceptions'
  autoload :Parser, 'fudge/parser'
  autoload :Runner, 'fudge/runner'
  autoload :Tasks, 'fudge/tasks'
end
