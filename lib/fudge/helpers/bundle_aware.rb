module Fudge
  module Helpers
    # Work with Bundler
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
