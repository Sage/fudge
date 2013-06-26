require 'rainbow'
require 'active_support/all'

#TODO: I think it will be safe to remove this once we start using Ruby 2.0
#This will fix errors: invalid byte sequence in US-ASCII (ArgumentError) when UTF-8 chars get
#in the console output.
if RUBY_VERSION =~ /1.9/
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

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

