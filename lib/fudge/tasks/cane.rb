module Fudge
  module Tasks
    # Allow use of Cane complexity and style analyser
    class Cane < Shell
      include Helpers::BundleAware

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
        args << doc_options
        args << style_options
        args << style_width_options
        args.compact
      end

      def doc_options
        "--no-doc" unless options.fetch(:doc, true)
      end

      def style_options
        "--no-style"  unless options.fetch(:style, true)
      end

      def style_width_options
        if options.has_key?(:max_width)
          "--style-measure #{options.fetch(:max_width)}"
        end
      end
    end

    register Cane
  end
end
