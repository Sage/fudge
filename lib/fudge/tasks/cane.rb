module Fudge
  module Tasks
    # Allow use of Cane complexity and style analyser
    class Cane < Shell
      include Helpers::BundleAware

      # Define task name
      def self.name
        :cane
      end

      private

      def cmd(options={})
        cmd = ["cane"] + tty_options
        bundle_cmd(cmd.join(' '), options)
      end

      def check_for
        /\A\Z/
      end

      def tty_options
        args = []
        doc = options.fetch(:doc, true)
        args << "--no-doc" unless doc
        args
      end
    end

    register Cane
  end
end
