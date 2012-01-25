module Fudge
  module Tasks
    class Rake < Shell
      def self.name
        :rake
      end

      private

      def cmd
        "rake #{arguments}"
      end
    end

    register Rake
  end
end
