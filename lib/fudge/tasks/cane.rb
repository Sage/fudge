module Fudge
  module Tasks
    # Allow use of Cane complexity and style analyser
    class Cane < Shell
      include Helpers::BundleAware

      # Define task name
      def self.name
        :cane
      end

      private

      def cmd(options={})
        bundle_cmd("cane", options)
      end

      def check_for
        /\A\Z/
      end
    end

    register Cane
  end
end
