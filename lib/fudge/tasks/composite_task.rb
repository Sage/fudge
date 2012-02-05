module Fudge
  module Tasks
    class CompositeTask
      attr_reader :tasks, :description

      # Sets the tasks to an initial empty array
      def initialize(description=nil, &block)
        @description = description
        @tasks = []
        instance_eval(&block) if block
      end

      # Adds a task to this task as a child
      def task(task_type, *args, &block)
        klass = Fudge::Tasks.discover(task_type)
        instance = if klass < CompositeTask
                     klass.new(description, *args, &block)
                   else
                     klass.new(*args, &block)
                   end
        @tasks << [instance, args]
      end

      # Adds a task group to this task with all tasks as children
      def task_group(name)
        instance_eval(&description.find_task_group(name))
      end

      # Allows the syntax of missing out the task keyword
      def method_missing(meth, *args, &block)
        task meth, *args, &block
      rescue Fudge::Exceptions::TaskNotFound
        super
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
