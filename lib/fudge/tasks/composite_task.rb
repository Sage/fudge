module Fudge
  module Tasks
    class CompositeTask < Task
      attr_reader :tasks
      attr_accessor :description

      # Sets the tasks to an initial empty array
      def initialize(*args, &block)
        super

        @tasks = []
        instance_eval(&block) if block
      end

      # Adds a task to this task as a child
      def task(task_type, *args, &block)
        klass = Fudge::Tasks.discover(task_type)

        instance_args = if klass < CompositeTask
                          insert_options(args, :description => description)
                        else
                          args
                        end

        instance = klass.new(*instance_args, &block)
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

      private
      def insert_options(array, hash)
        if array.last.is_a? Hash
          array[0...1] + [array.last.merge(hash)]
        else
          array + [hash]
        end
      end
    end
  end
end
