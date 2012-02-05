module Fudge
  module Tasks
    class Yard < Shell
      attr_accessor :coverage

      def self.name
        :yard
      end

      private

      def cmd
        "yard #{arguments}"
      end

      def check_for
        if coverage
          [/(\d+\.\d+)% documented/, lambda { |matches| matches[1].to_f >= coverage ? true : 'Insufficient Documentation.' }]
        else
          super
        end
      end
    end

    register Yard
  end
end
