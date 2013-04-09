module Fudge
  module Tasks
    # Provides a sanitized running environment for Bundler
    class CleanBundlerEnv < CompositeTask
      def run(options={})
        Bundler.with_clean_env do
          super(options.merge(:bundler => true))
        end
      end
    end

    register CleanBundlerEnv
  end
end
