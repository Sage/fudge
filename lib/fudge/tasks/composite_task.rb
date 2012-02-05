module Fudge
  module Tasks
    class CompositeTask < Task
      attr_reader :tasks
      attr_accessor :description

      # Sets the tasks to an initial empty array
      def initialize(*args)
        super

        @tasks = []
      end

      # Runs the task (by default running all other tasks in order)
      def run
        @tasks.each do |t, args|
          puts "Running task ".foreground(:blue) +
            t.class.name.to_s.foreground(:yellow).bright + ' ' +
            args.join(', ').foreground(:yellow).bright

          return unless t.run
        end
      end
    end
  end
end
