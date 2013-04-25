module Fudge
  # Represents a build defined in the FudgeFile
  #
  class Build < Tasks::CompositeTask
    attr_accessor :callbacks
    attr_reader :success_hooks, :failure_hooks

    def initialize(*args)
      @success_hooks = []
      @failure_hooks = []

      super
    end

    def run(options={})
      output = options[:output] || $stdout
      success = super
      if callbacks
        message "Running #{success ? 'success' : 'failure'} callbacks...", output
        hooks = success ? @success_hooks : @failure_hooks

        hooks.each do |hook|
          return false unless hook.run :output => output
        end
      else
        message "Skipping callbacks...", output
      end

      success
    end

    private

    def message(message, output)
      output.puts message.foreground(:cyan).bright
    end
  end
end
