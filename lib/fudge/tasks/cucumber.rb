module Fudge
  module Tasks
    # Allow use of Cucumber as a task
    class Cucumber < Shell
      include Helpers::BundleAware

      private

      def check_for
        if coverage
          [check_regex, method(:coverage_checker)]
        else
          super
        end
      end

      def check_regex
        /((\d+\.\d+)%\) covered)/
      end

      def coverage
        options[:coverage]
      end

      # checks if the expected coverage is met
      def coverage_checker(matches)
        matches = matches.to_s
        test_coverage_threshold(matches)
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

      def color_options
        ' --color' unless color == false
      end

      def cmd(options={})
        self.arguments = 'features/' if (arguments.nil? || arguments.empty?)
        bundle_cmd("cucumber#{color_options} #{arguments}", options)
      end

      def color
        options[:color]
      end
    end

    register Cucumber
  end
end
