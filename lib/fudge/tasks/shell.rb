module Fudge
  module Tasks
    # Allow use of shell commands as tasks
    class Shell < Task
      attr_accessor :arguments, :check_for

      def initialize(*args)
        self.arguments = super.join(' ')
      end

      # Execute the shell command
      #
      # @param [Hash] options Any options to pass to the shell
      def run(options={})
        formatter = get_formatter(options)
        @output, success = run_command(cmd(options), formatter)

        return false unless success
        return check_for_output(formatter)
      end

      private

      def run_command(cmd, formatter)
        output = ''
        IO.popen(cmd) do |f|
          until f.eof?
            bit = f.getc
            output << bit
            formatter.putc bit
          end
        end

        unless $?.zero?
          formatter.error("Shell command failed. Exit code: #{$?}")
        end

        [output, $?.success?]
      end

      def check_for_output(formatter)
        checker = OutputChecker.new(check_for, formatter)
        checker.check(@output)
      end

      # Defines the command to run
      def cmd(options={})
        arguments
      end
    end

    register Shell
  end
end
