require 'fudge/fudge_file/task_registry'

module Fudge
  module FudgeFile
    module Tasks
      class Rspec
        DEFAULT_OPTIONS = { :path => 'spec/' }

        def initialize(options={})
          @options = DEFAULT_OPTIONS.merge(options)
        end

        def run
          system("rspec #{@options[:path]}")
        end
      end
    end

    TaskRegistry.register(:rspec, Tasks::Rspec)
  end
end
