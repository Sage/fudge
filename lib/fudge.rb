require 'rainbow'
require 'active_support/all'

# Fudge implementation
module Fudge
  autoload :Build, 'fudge/build'
  autoload :Cli, 'fudge/cli'
  autoload :Description, 'fudge/description'
  autoload :Exceptions, 'fudge/exceptions'
  autoload :Generator, 'fudge/generator'
  autoload :Helpers, 'fudge/helpers'
  autoload :Parser, 'fudge/parser'
  autoload :Runner, 'fudge/runner'
  autoload :Tasks, 'fudge/tasks'
  autoload :TaskDSL, 'fudge/task_dsl'
  autoload :WithDirectory, 'fudge/with_directory'
  autoload :OutputChecker, 'fudge/output_checker.rb'
  autoload :FileFinder, 'fudge/file_finder.rb'
end

