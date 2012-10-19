module Fudge
  module Tasks
    # Provides a sanitized running environment for Bundler
    class CleanBundlerEnv < CompositeTask
      # Task name
      def self.name
        :clean_bundler_env
      end

      def run(options={})
        old_env = ENV
        keys = ENV.keys.grep(/BUNDLE|RUBY/)

        keys.each { |k| ENV[k] = nil }

        result = super(options.merge(:bundler => true))

        keys.each { |k| ENV[k] = old_env[k] }

        result
      end
    end

    register CleanBundlerEnv
  end
end
