module Fudge
  module FudgeFile
    module Tasks
      class Rspec
        DEFAULT_OPTIONS = { :path => 'spec/' }

        def self.name
          :rspec
        end

        def initialize(options={})
          @options = DEFAULT_OPTIONS.merge(options)
        end

        def run
          system("rspec #{@options[:path]}")
        end
      end

      TaskRegistry.register(Tasks::Rspec)
    end
  end
end
