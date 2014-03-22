module Fudge
  module Formatters
    # Simple coloured STDOUT/STDERR formatting
    class Simple

      # ASCII Color Codes
      CODE = {
        :off => 0,
        :bright => 1,
        :red => 31,
        :green => 32,
        :yellow => 33,
        :cyan => 36
      }

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
        ascii :red, message
      end

      # Report Success Message
      def success(message)
        ascii :bright, :green, message
      end

      # Report Information Message
      def info(message)
        ascii :cyan, message
      end

      # Report Notice Message
      def notice(message)
        ascii :yellow, message
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

      private

      def ascii(*args)
        txt = args.pop
        codes = args.map { |a| coded(a) }
        codes << txt << coded(:off)
        codes.join ''
      end

      def coded(code)
        "\e[#{CODE[code]}m"
      end
    end
  end
end
