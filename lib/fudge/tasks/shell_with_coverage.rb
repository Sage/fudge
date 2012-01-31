module Fudge
  module Tasks
    class ShellWithCoverage < Shell
      attr_accessor :coverage, :suffix

      def self.name
        :shell_with_coverage
      end

      def run
        ok = super
        return unless ok

        match = @output.match(/(\d+(?:\.\d+)?)%#{suffix}/)

        unless match
          puts "No coverage output found."
          return false
        end

        sufficient_coverage = match[1].to_i >= coverage
        unless sufficient_coverage
          puts "Inufficient coverage."
          return false
        end

        true
      end
    end

    register ShellWithCoverage
  end
end
