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
      output_start(which_build)
      status = run(which_build, options)
      output_status(status)
    end

    private

    def output_start(which)
      which_build = String.new(which)

      puts "Running build ".foreground(:cyan) +
        which_build.bright.foreground(:yellow)
    end

    def run(which, options)
      # Run the build
      build = @description.builds[which.to_sym]
      build.callbacks = options[:callbacks]
      build.run
    end

    def output_status(success)
      # Output status
      if success
        puts "Build SUCCEEDED!".foreground(:green).bright
      else
        raise Exceptions::BuildFailed
      end
    end
  end
end
