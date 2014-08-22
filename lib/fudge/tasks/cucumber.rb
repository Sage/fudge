module Fudge
  module Tasks
    # Allow use of Cucumber as a task
    class Cucumber < Shell
      include Helpers::BundleAware

      private

      def color_options
        ' --color' unless color == false
      end

      def cmd(options={})
        self.arguments = 'features/' if (arguments.nil? || arguments.empty?)
        bundle_cmd("cucumber#{color_options} #{arguments}", options)
      end

      def color
        options[:color]
      end
    end

    register Cucumber
  end
end
