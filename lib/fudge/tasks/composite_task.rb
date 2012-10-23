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
          args_text = join_arguments(t)

          puts [
            "Running task".foreground(:blue),
            t.class.name.to_s.foreground(:yellow).bright,
            args_text.foreground(:yellow).bright
          ].join(' ')
      end
    end
  end
end
