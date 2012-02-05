module Fudge
  # Represents a build defined in the FudgeFile
  #
  class Build < Tasks::CompositeTask
    attr_accessor :callbacks

    def initialize(*args)
      super

      @success_hooks = []
      @failure_hooks = []
    end

    def on_success(&block)
      @success_hooks << Fudge::Tasks::CompositeTask.new(
        :description => description, &block)
    end

    def on_failure(&block)
      @failure_hooks << Fudge::Tasks::CompositeTask.new(
        :description => description, &block)
    end


    def run
      success = super
      if callbacks
        hooks = success ? @success_hooks : @failure_hooks

        hooks.each do |hook|
          return false unless hook.run
        end
      end

      success
    end
  end
end
