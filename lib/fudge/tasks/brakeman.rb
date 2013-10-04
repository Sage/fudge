module Fudge
  module Tasks
    # Allow use of Brakeman securty scanner
    #
    #    task :brakeman
    # runs brakeman with max score of 0
    #
    #    task :brakeman, :max => 2
    #
    # sets max score to 2
    #
    # Any and all options can be defined
    #
    # task :brakeman
    class Brakeman < Shell
      include Helpers::BundleAware

      private

      def cmd(options={})
        bundle_cmd("brakeman #{arguments}", options)
      end


      def check_for
        [check_regex, method(:brakeman_checker)]
      end

      def check_regex
        /\| Security Warnings \| (?<score>\d+) /
      end

      def brakeman_checker(matches)
        score = matches[:score].to_i
        if score > max_score
          "Brakeman reported more than #{max_score} issues."
        else
          true
        end
      end

      def max_score
        options.fetch(:max, 0)
      end

    end

    register Brakeman
  end
end
