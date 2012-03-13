module Fudge
  module Tasks
    class Yard < Shell
      include Helpers::BundleAware

      attr_accessor :coverage

      def self.name
        :yard
      end

      private

      def cmd(options={})
        bundle_cmd("yard #{arguments}", options)
      end

      def check_for
        if coverage
          [/(\d+\.\d+)% documented/, lambda { |matches| matches[1].to_f >= coverage ? true : 'Insufficient Documentation.' }]
        else
          super
        end
      end
    end

    register Yard
  end
end
