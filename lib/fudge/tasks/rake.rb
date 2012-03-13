module Fudge
  module Tasks
    class Rake < Shell
      include Helpers::BundleAware

      def self.name
        :rake
      end

      private

      def cmd(options={})
        bundle_cmd("rake #{arguments}", options)
      end
    end

    register Rake
  end
end
