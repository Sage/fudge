module Fudge
  module Tasks
    class CompositeTask
      attr_reader :tasks

      # Sets the tasks to an initial empty array
      def initialize(&block)
        @tasks = []
        instance_eval(&block) if block
      end

      # Adds a task to this task as a child
      def task(task_type, *args, &block)
        @tasks << Fudge::Tasks.discover(task_type).new(*args, &block)
      end

      # Allows the syntax of missing out the task keyword
      def method_missing(meth, *args, &block)
        task meth, *args, &block
      end

      # Runs the task (by default running all other tasks in order)
      def run
        @tasks.each do |t|
          puts "Running task ".foreground(:blue) + t.class.name.to_s.foreground(:blue).bright + "...".foreground(:blue)

          return unless t.run
        end
      end
    end
  end
end
