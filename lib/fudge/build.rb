module Fudge
  # Represents a build defined in the FudgeFile
  #
  class Build < Tasks::CompositeTask
    # @!attribute about
    #   @return [String] a brief description of the build; this is
    #                    output by the 'list' command
    attr_accessor :about
    attr_accessor :callbacks, :time
    attr_reader :success_hooks, :failure_hooks
    attr_reader :description
    attr_reader :formatter

    def initialize(*args)
      @success_hooks = []
      @failure_hooks = []

      super
    end

    # Run task
    def run(options={})
      start_time = Time.new
      init_formatter(options)
      success = super
      if callbacks
        return false unless run_callbacks(success)
      else
        message "Skipping callbacks..."
      end
      report_time(start_time, time)

      success
    end

    private

    def message(message)
      formatter.write { |w| w.info(message) }
    end

    def init_formatter(options)
      @formatter = options[:formatter] || Fudge::Formatters::Simple.new
    end

    def report_time(start_time, time)
      message "Finished in #{"%.2f" % (Time.new - start_time)} seconds." if time
    end

    def run_callbacks(success)
      message "Running #{success ? 'success' : 'failure'} callbacks..."
      hooks = success ? @success_hooks : @failure_hooks

      hooks.each do |hook|
        return false unless hook.run :formatter => formatter
      end
    end
  end
end
