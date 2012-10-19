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
        bundle_cmd("rspec#{' --tty' unless color == false} #{arguments}", options)
      end

      def check_for
        if coverage
          [/(\d+\.\d+)%\) covered/, lambda { |matches| matches[1].to_f >= coverage ? true : 'Insufficient Coverage.' }]
        else
          super
        end
      end
    end

    register Rspec
  end
end
