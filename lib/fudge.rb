require 'git'
require 'rainbow'

module Fudge
  autoload :Queue, 'fudge/queue'
  autoload :FudgeFile, 'fudge/fudge_file'
  autoload :Models, 'fudge/models'
  autoload :Server, 'fudge/server'
  autoload :Exceptions, 'fudge/exceptions'
  autoload :DataStore, 'fudge/data_store'
  autoload :Cli, 'fudge/cli'
  autoload :Config, 'fudge/config'
end
