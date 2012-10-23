module Fudge
  module Tasks
    # Allow use of rake as a supported task
    class Rake < Shell
      include Helpers::BundleAware

      private

      def cmd(options={})
        bundle_cmd("rake #{arguments}", options)
      end
    end

    register Rake
  end
end
