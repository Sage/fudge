module Fudge
  module Tasks
    class Shell < Task
      attr_accessor :arguments

      def self.name
        :shell
      end

      def initialize(*args)
        self.arguments = super.join(' ')
      end

      def run
        @output = run_command(cmd)
        $?.success?
      end

      private

      def run_command(cmd)
        output = ''
        IO.popen(cmd) do |f|
          until f.eof?
            bit = f.getc
            output << bit
            putc bit
          end
        end

        output
      end

      def cmd
        arguments
      end
    end

    register Shell
  end
end
