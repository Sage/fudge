module Fudge
  module Tasks
    # Allow use of RSpec as a task
    class Rspec < Shell
      include Helpers::BundleAware

      attr_accessor :color, :coverage

      # Define task name
      def self.name
        :rspec
      end

      private
      def cmd(options={})
        self.arguments = 'spec/' if arguments.blank?
        bundle_cmd("rspec#{tty_options} #{arguments}", options)
      end

      def tty_options
        ' --tty' unless color == false
      end

      def check_for
        if coverage
          [/(\d+\.\d+)%\) covered/, method(:coverage_checker)]
        else
          super
        end
      end

      def coverage_checker(matches)
        matches[1].to_f >= coverage ? true : 'Insufficient Coverage.'
      end
    end

    register Rspec
  end
end
