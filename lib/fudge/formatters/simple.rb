module Fudge
  module Formatters
    # Simple coloured STDOUT/STDERR formatting
    class Simple

      # Internal wrapper for output
      class Writer
        def initialize(formatter)
          @parts = []
          @formatter = formatter
        end

        # Writes the final message
        def write(out)
          out.puts @parts.join(' ')
        end

        # Determines which formatter methods to make available
        def self.wrap(*methods)
          methods.each do |m|
          class_eval  <<-RUBY
      def #{m}(message)
        @parts << @formatter.#{m}(message)
        self
      end
RUBY
          end
        end

        wrap :normal, :notice, :info, :success, :error

      end

      attr_reader :stdout

      def initialize(stdout=$stdout)
        @stdout = stdout
      end

      # Report Error Message
      def error(message)
        message.foreground(:red)
      end

      # Report Success Message
      def success(message)
        message.foreground(:green).bright
      end

      # Report Information Message
      def info(message)
        message.foreground(:cyan)
      end

      # Report Notice Message
      def notice(message)
        message.foreground(:yellow)
      end

      # Normal information
      def normal(message)
        message
      end

      # Directly output
      def puts(message)
        stdout.puts message
      end

      # Yields a writer which can chain message types to output
      def write
        w = Writer.new(self)
        yield w
        w.write(stdout)
      end

      # Output a character
      def putc(c)
        stdout.putc(c)
      end
    end
  end
end
