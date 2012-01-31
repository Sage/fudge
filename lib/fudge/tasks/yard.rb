module Fudge
  module Tasks
    class Yard < ShellWithCoverage
      def self.name
        :yard
      end

      private

      def cmd
        "yard #{arguments}"
      end

      def suffix
        ' documented'
      end
    end

    register Yard
  end
end
