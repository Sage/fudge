module Fudge
  # Represents a build defined in the FudgeFile
  #
  class Build < Tasks::CompositeTask
    attr_accessor :callbacks

    def initialize(*args)
      @success_hooks = []
      @failure_hooks = []

      super
    end

    def on_success(&block)
      task = Fudge::Tasks::CompositeTask.new(
        :description => description, &block)
      @success_hooks << task
    end

    def on_failure(&block)
      @failure_hooks << Fudge::Tasks::CompositeTask.new(
        :description => description, &block)
    end


    def run
      success = super
      if callbacks
        puts "Running #{success ? 'success' : 'failure'} callbacks...".foreground(:red).bright
        hooks = success ? @success_hooks : @failure_hooks

        hooks.each do |hook|
          return false unless hook.run
        end
      else
        puts "Skipping callbacks...".foreground(:red).bright
      end

      success
    end
  end
end
