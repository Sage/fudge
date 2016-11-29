require 'yaml'

module Fudge
  module Tasks
    # Allow for tasks to be combined
    class CompositeTask < Task
      require 'yaml'
      
      attr_accessor :description

      # Define task array
      def tasks
        @tasks ||= []
      end

      # Runs the task (by default running all other tasks in order)
      def run(options={})
        formatter = get_formatter(options)
        tasks.each do |t|
          apply_directory_settings(t)
          output_message(t, formatter)
          return unless t.run(options)
        end
      end

      private

      # load fudge settings for the specified task, by name
      def apply_directory_settings(task)
        task.options.merge!(task_options(task.class.name.to_s)) if defined? task.options
      end

      # Load the fudge_settings.yml for the current directory and return
      # the options contained for the specified task
      def task_options(task_name)
        # are there settings for the specified task?
        settings = fudge_settings.fetch(task_name, {})
        key_syms = settings.map do |k, v|
          key = k.to_sym rescue k
          [key, v]
        end
        Hash[key_syms]
      end

      # load fudge settings for the current directory
      def fudge_settings
        fpath = "#{Dir.pwd}/fudge_settings.yml"
        if File.exist?(fpath)
          return ::YAML.load_file(fpath)
        end
        {}
      end

      def task_name(t)
        t.class.name.to_s
      end

      def args_s(t)
        t.respond_to?(:args) && t.args ? t.args.join(', ') : ''
      end

      def output_message(t, formatter)
        name = task_name(t)
        args = args_s(t)
        formatter.write do |w|
          w.info("Running task").notice(name).notice(args)
        end
      end

    end
  end
end
