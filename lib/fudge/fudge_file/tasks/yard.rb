module Fudge
  module FudgeFile
    module Tasks
      class Yard
        def self.name
          :yard
        end

        def initialize(options={})
          @options = options
        end

        def run
          cmd = "yard"
          cmd << " #{arguments}" if arguments

          output = `#{cmd}`
          return false unless $?.success?

          if coverage
            return false unless Fudge::FudgeFile::Utils::CoverageChecker.new.check(output, ' documented', coverage)
          end

          true
        end

        private
        def coverage
          @options[:coverage]
        end

        def arguments
          @options[:arguments]
        end
      end
      TaskRegistry.register(Yard)
    end
  end
end
