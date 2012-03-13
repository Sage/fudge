module Fudge
  module Helpers
    module BundleAware
      private
      def bundle_cmd(original, options={})
        if options[:bundler]
          "bundle exec #{original}"
        else
          original
        end
      end
    end
  end
end
