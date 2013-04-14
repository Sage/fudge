module Fudge
  module Tasks
    # Allow for tasks to be combined
    class CompositeTask < Task
      attr_accessor :description

      # Define task array
      def tasks
        @tasks ||= []
      end

      # Runs the task (by default running all other tasks in order)
      def run(options={})
        tasks.each do |t|
          output_message(t)

          return unless t.run(options)
        end
      end

      private

      def join_arguments(t)
        t.respond_to?(:args) && t.args ? t.args.join(', ') : ''
      end

      def output_message(t)
          message = []
          message << running_coloured
          message << task_name_coloured(t)
          message << args_coloured(t)
          puts message.join(' ')
      end

      def running_coloured
        "Running task".foreground(:blue)
      end

      def task_name_coloured(t)
        t.class.name.to_s.foreground(:yellow).bright
      end

      def args_coloured(t)
        args_text = join_arguments(t)
        args_text.foreground(:yellow).bright
      end
    end
  end
end
