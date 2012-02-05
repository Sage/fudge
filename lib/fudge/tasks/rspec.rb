module Fudge
  module Tasks
    class Rspec < Shell
      attr_accessor :color, :coverage

      def self.name
        :rspec
      end

      private
      def cmd
        self.arguments = 'spec/' if arguments.blank?
        "rspec#{' --tty' unless color == false} #{arguments}"
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
