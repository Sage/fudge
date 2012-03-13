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
        puts "Running #{success ? 'success' : 'failure'} callbacks...".foreground(:cyan).bright
        hooks = success ? @success_hooks : @failure_hooks

        hooks.each do |hook|
          return false unless hook.run
        end
      else
        puts "Skipping callbacks...".foreground(:cyan).bright
      end

      success
    end
  end
end
