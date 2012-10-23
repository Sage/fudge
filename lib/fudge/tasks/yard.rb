module Fudge
  module Tasks
    # Allow use of Yard as a supported task
    class Yard < Shell
      include Helpers::BundleAware

      attr_accessor :coverage

      private

      def cmd(options={})
        bundle_cmd("yard #{arguments}", options)
      end

      def arguments
        args = super
        if args.empty?
          "stats --list-undoc"
        else
          args
        end
      end

      def check_for
        if coverage
          [/(\d+\.\d+)% documented/, method(:coverage_checker)]
        else
          super
        end
      end

      def coverage_checker(matches)
        matches[1].to_f >= coverage ? true : 'Insufficient Documentation.'
      end
    end

    register Yard
  end
end
