module Fudge
  module Tasks
    class CleanBundlerEnv < CompositeTask
      def self.name
        :clean_bundler_env
      end

      def run
        old_env = ENV
        keys = ENV.keys.grep(/BUNDLE|RUBY/)

        keys.each { |k| ENV[k] = nil }
        super
        keys.each { |k| ENV[k] = old_env[k] }
      end
    end

    register CleanBundlerEnv
  end
end
