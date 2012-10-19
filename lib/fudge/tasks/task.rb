module Fudge
  module Tasks
    # Implementation of base Task
    class Task
      attr_reader :args

      def initialize(*args)
        @args = args.dup
        options = args.extract_options!

        options.each do |k,v|
          send("#{k}=", v) if respond_to?("#{k}=")
        end

        args
      end
    end
  end
end
