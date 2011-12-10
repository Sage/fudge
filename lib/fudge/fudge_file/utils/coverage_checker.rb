module Fudge
  module FudgeFile
    module Utils
      class CoverageChecker
        def check(output, suffix, sufficient)
          match = output.match(/(\d+\.\d+)%#{suffix}/)

          unless match
            puts "No coverage output found."
            return false
          end

          sufficient_coverage = match[1].to_i >= sufficient
          unless sufficient_coverage
            puts "Inufficient coverage."
            return false
          end

          true
        end
      end
    end
  end
end
