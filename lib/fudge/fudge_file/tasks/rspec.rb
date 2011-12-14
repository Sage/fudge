module Fudge
  module FudgeFile
    module Tasks
      class Rspec
        DEFAULT_OPTIONS = { :path => 'spec/', :color => true }

        def self.name
          :rspec
        end

        def initialize(options={})
          @options = DEFAULT_OPTIONS.merge(options)
        end

        def run
          output = Fudge::FudgeFile::Utils::CommandRunner.new.run(
            "rspec#{' --tty' if color} #{path}"
          )
          return false unless $?.success?

          if coverage
            return false unless Fudge::FudgeFile::Utils::CoverageChecker.new.check(output, '\) covered', coverage)
          end

          true
        end

        private
        def coverage
          @options[:coverage]
        end

        def path
          @options[:path]
        end

        def color
          @options[:color]
        end
      end

      TaskRegistry.register(Tasks::Rspec)
    end
  end
end
