module Fudge
  module Tasks
    # Implementation of base Task
    class Task
      attr_reader :args, :options

      # Default name derived from class name.
      # Can be overriden by specific tasks.
      #
      # @return [Symbol]
      def self.name
        super.demodulize.underscore.downcase.to_sym
      end

      def initialize(*args)
        @args = args.dup
        @options = @args.extract_options!

        @options.each do |k,v|
          send("#{k}=", v) if respond_to?("#{k}=")
        end

        @args
      end

      private
      def get_formatter(options = {})
        options[:formatter] || Fudge::Formatters::Simple.new
      end
    end
  end
end
