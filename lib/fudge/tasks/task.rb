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
        name = /(\w+::)*(?<class>\w+\z)/.match(super)[:class]
        underscored = name.gsub(/(?<pre>[^_])(?<char>[A-Z])/, "\\k<pre>_\\k<char>")
        underscored.downcase.to_sym
      end

      def initialize(*args)
        @args = args.dup
        @options = @args[-1].kind_of?(Hash) ? @args.delete_at(-1) : {}

        @options.each do |k,v|
          send("#{k}=", v) if respond_to?("#{k}=")
        end

        @args
      end
    end
  end
end
