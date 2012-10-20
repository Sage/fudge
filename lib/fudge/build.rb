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
      success = super
      if callbacks
        message "Running #{success ? 'success' : 'failure'} callbacks..."
        hooks = success ? @success_hooks : @failure_hooks

        hooks.each do |hook|
          return false unless hook.run
        end
      else
        message "Skipping callbacks..."
      end

      success
    end

    private

    def message(message)
      puts message.foreground(:cyan).bright
    end
  end
end
