module Fudge
  module Tasks
    class CompositeTask < Task
      class_attribute :tasks
      class_eval { self.tasks = [] }

      attr_reader :tasks
      attr_accessor :description

      # Sets the tasks to an initial empty array
      def initialize(*args)
        super

        @tasks = []
        self.class.tasks.each do |name, *args|
          @tasks << Fudge::Tasks.discover(name).new(*args)
        end
      end

      # Runs the task (by default running all other tasks in order)
      def run
        @tasks.each do |t|
          args_text = t.respond_to?(:args) ? t.args.join(', ') : ''

          puts "Running task ".foreground(:blue) +
            t.class.name.to_s.foreground(:yellow).bright + ' ' +
            args_text.foreground(:yellow).bright

          return unless t.run
        end
      end

      # Class attribute that allows you to define tasks in a tidy way
      def self.task(*args)
        self.tasks += [args]
      end
    end
  end
end
