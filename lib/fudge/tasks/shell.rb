module Fudge
  module Tasks
    class Shell < Task
      attr_accessor :arguments, :check_for

      def self.name
        :shell
      end

      def initialize(*args)
        self.arguments = super.join(' ')
      end

      def run
        @output, success = run_command(cmd)
        return unless success
        return check_for_output
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

        [output, $?.success?]
      end

      def check_for_output
        return true unless check_for # We're ok if no output defined

        # Check if we have a callable to parse the regex matches
        if check_for.is_a? Enumerable
          regex, pass_if = check_for[0], check_for[1]
        else
          regex, pass_if = check_for, nil
        end

        # Do regex match and fail if no match
        match = @output.match(regex)
        unless match
          puts "Output didn't match #{regex}."
          return false
        end

        # If we've got a callable, call it to check on regex matches
        if pass_if
          passed = pass_if.call(match)
          unless passed == true
            if passed.is_a? String
              puts passed
            else
              puts "Output matched #{check_for} but condition failed."
            end
            return false
          end
        end

        true
      end

      # Defines the command to run
      def cmd
        arguments
      end
    end

    register Shell
  end
end
