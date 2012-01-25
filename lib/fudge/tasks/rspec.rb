module Fudge
  module Tasks
    class Rspec < ShellWithCoverage
      attr_accessor :color

      def self.name
        :rspec
      end

      private
      def cmd
        self.arguments = 'spec/' if arguments.blank?
        "rspec#{' --tty' unless color == false} #{arguments}"
      end

      def suffix
        '\) covered'
      end
    end

    register Rspec
  end
end
