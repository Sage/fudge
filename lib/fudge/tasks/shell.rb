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
        output_io = options[:output] || $stdout
        @output, success = run_command(cmd(options), output_io)

        return false unless success
        return check_for_output(output_io)
      end

      private

      def run_command(cmd, output_io)
        output = ''
        IO.popen(cmd) do |f|
          until f.eof?
            bit = f.getc
            output << bit
            output_io.putc bit
          end
        end

        [output, $?.success?]
      end

      def check_for_output(output_io)
        checker = OutputChecker.new(check_for, output_io)
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
