module Fudge
  module Tasks
    class CompositeTask < Task
      attr_accessor :description

      def tasks
        @tasks ||= []
      end

      # Runs the task (by default running all other tasks in order)
      def run
        tasks.each do |t|
          args_text = t.respond_to?(:args) && t.args ? t.args.join(', ') : ''

          puts "Running task ".foreground(:blue) +
            t.class.name.to_s.foreground(:yellow).bright + ' ' +
            args_text.foreground(:yellow).bright

          return unless t.run
        end
      end
    end
  end
end
