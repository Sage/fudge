module Fudge
  module Tasks
    class Task
      def initialize(*args)
        options = args.extract_options!

        options.each do |k,v|
          send("#{k}=", v) if respond_to?("#{k}=")
        end

        args
      end
    end
  end
end
