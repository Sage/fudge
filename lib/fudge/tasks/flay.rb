module Fudge
  module Tasks
    # Allow use of Flay complexity analyser
    #
    #    task :flay
    #
    # runs flay with max score of 0
    #
    #    task :flay, :exclude => 'subpath/'
    #
    # excludes files matching :exclude from run
    #
    #    task :flay, :max => 20
    #
    # sets max score to 20
    #
    # Any and all options can be defined
    #
    class Flay < Shell
      include Helpers::BundleAware

      private

      def cmd(options={})
        bundle_cmd(flay_ruby_files, options)
      end

      def flay_ruby_files
        finder = FileFinder.new(options)
        finder.generate_command("flay", tty_options)
      end

      def check_for
        [check_regex, method(:flay_checker)]
      end

      def check_regex
        /Total score \(lower is better\) = (?<score>\d+)/
      end

      def flay_checker(matches)
        score = matches[:score].to_i
        if score > max_score
          "Duplication Score Higher Than #{max_score}"
        else
          true
        end
      end

      def max_score
        options.fetch(:max, 0)
      end

      def tty_options
        opts = []
        opts << "--diff"
        opts
      end

    end

    register Flay
  end
end
