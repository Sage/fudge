module Fudge
  # Executes the build
  class Runner
    def initialize(description)
      @description = description
    end

    # Run the specified build
    #
    # @param [String] which_build Defaults to 'default'
    def run_build(which_build='default', options={})
      formatter = options[:formatter] || Fudge::Formatters::Simple.new
      output_start(which_build, formatter)
      status = run(which_build, options)
      output_status(status, formatter)
    end

    private

    def output_start(which, formatter)
      which_build = String.new(which)
      formatter.write { |w| w.info('Running build').notice(which_build) }
    end

    def run(which, options)
      # Run the build
      build = @description.builds[which.to_sym]
      build.callbacks = options[:callbacks]
      build.time = options[:time]
      build.run :formatter => options[:formatter]
    end

    def output_status(success, formatter)
      # Output status
      if success
        formatter.write { |w| w.success('Build SUCCEEDED!') }
      else
        formatter.write { |w| w.error("Build FAILED!") }
        raise Exceptions::BuildFailed
      end
    end
  end
end
