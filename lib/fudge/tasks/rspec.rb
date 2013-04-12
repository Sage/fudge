module Fudge
  module Tasks
    # Allow use of RSpec as a task
    class Rspec < Shell
      include Helpers::BundleAware

      attr_accessor :color, :coverage

      private

      # Preconditions to check for coverage, that if not met make the test pass
      # for example, if no tests exist, no need to fail
      def pre_conditions_regex
         /(0 examples, 0 failures)/ # no tests exist
      end

      # Expression to check for coverage
      def coverage_regex
        /((\d+\.\d+)%\) covered)/
      end

      def check_regex
        Regexp.union(coverage_regex, pre_conditions_regex)
      end

      def cmd(options={})
        self.arguments = 'spec/' if arguments.blank?
        bundle_cmd("rspec#{tty_options} #{arguments}", options)
      end

      def tty_options
        ' --tty' unless color == false
      end

      def check_for
        if coverage
          [check_regex, method(:coverage_checker)]
        else
          super
        end
      end

      # will check if the expected coverage is met,
      # but first will test for pre conditions to pass
      def coverage_checker(matches)
        matches = matches.to_s
        if matches.match(pre_conditions_regex)
          true
        else
          test_coverage_threshold(matches)
        end
      end

      # checks the matched string from the console output,
      # to see if the number for the coverage is greater or
      # equal than the expected coverage
      def test_coverage_threshold(matches)
        if matches.to_f >= coverage
          true
        else
          'Insufficient Coverage.'
        end
      end
    end

    register Rspec
  end
end
