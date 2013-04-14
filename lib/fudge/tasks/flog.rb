module Fudge
  module Tasks
    # Allow use of Flog complexity analyser
    #
    #    task :flog
    #
    # runs flog with max score of 10.0 for a method, 5.0 average
    #
    #    task :flog, :exclude => 'subpath/'
    #
    # excludes files matching :exclude from run
    #
    #    task :flog, :max => 20.0
    #
    # sets max score for a method to 20.0
    #
    #    task :flog, :average => 10.0
    #
    # sets required average to 10.0
    #
    #    task :flog, :methods => true
    #
    # runs only scoring methods, not classes macros etc
    #
    # Any and all options can be defined
    #
    class Flog < Shell
      include Helpers::BundleAware

      private

      def cmd(options={})
        bundle_cmd(flog_ruby_files, options)
      end

      def flog_ruby_files
        finder = FileFinder.new(options)
        finder.generate_command("flog", tty_options)
      end

      def check_for
        [check_regex, method(:flog_checker)]
      end

      def check_regex
        /^\s*(?<score>\d+.\d+): (?<type>.*)$/
      end

      def flog_checker(matches)
        average, max = extract_scores(matches)
        if average > average_required
          "Average Complexity Higher Than #{average_required}"
        elsif max > max_score
          "Maximum Complexity Higher Than #{max_score}"
        else
          true
        end
      end

      def average_required
        options.fetch(:average, 5.0).to_f
      end

      def max_score
        options.fetch(:max, 10.0).to_f
      end

      def extract_scores(matches)
        lines = extract_lines(matches)
        _, average, max, _ = lines
        [average.first.to_f, max.first.to_f]
      end

      def extract_lines(matches)
        output = matches.string
        output.scan(check_regex)
      end

      def tty_options
        opts = []
        opts << "-m" if options[:methods]
        opts
      end

    end

    register Flog
  end
end
