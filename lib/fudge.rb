require 'active_support/all'

#This will fix errors: invalid byte sequence in US-ASCII (ArgumentError) when UTF-8 chars get
#in the console output, ruby pre-2.0 only.
Encoding.default_external = Encoding.default_internal = Encoding::UTF_8 if RUBY_VERSION =~ /1.9/

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
  autoload :OutputChecker, 'fudge/output_checker'
  autoload :FileFinder, 'fudge/file_finder'
  autoload :Formatters, 'fudge/formatters'
end

