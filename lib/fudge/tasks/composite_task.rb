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
        output = options[:output] || $stdout
        tasks.each do |t|
          # load fudge settings in the current directory
          t.options.merge!(task_options(t.class.name.to_s)) if defined? t.options
          output_message(t, output)

          return unless t.run(options)
        end
      end

      private

      # Load the fudge_settings.yml for the current directory and return
      # the options contained for the specified task
      def task_options(task_name)
        # load fudge settings for the current directory
        fpath = "#{Dir.pwd}/fudge_settings.yml"
        if File.exist?(fpath)
          if fsettings = YAML.load_file(fpath)
            if section = fsettings[task_name]
              # convert the options for this task from strings to symbols
              return section.inject({}){|m,(k,v)| m[k.to_sym] = v; m}
            end
          end
        end
        # otherwise, nothing
        {}
      end

      def join_arguments(t)
        t.respond_to?(:args) && t.args ? t.args.join(', ') : ''
      end

      def output_message(t, output)
          message = []
          message << running_coloured
          message << task_name_coloured(t)
          message << args_coloured(t)
          output.puts message.join(' ')
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
