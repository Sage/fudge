module Fudge
  class Runner
    def initialize(description)
      @description = description
    end

    def run_build(which_build='default', options={})
      which_build = String.new(which_build)

      puts "Running build ".foreground(:cyan) + which_build.bright.foreground(:yellow)

      # Run the build
      build = @description.builds[which_build.to_sym]
      build.callbacks = options[:callbacks]
      status = build.run

      # Output status
      if status
        puts "Build SUCCEEDED!".foreground(:green).bright
      else
        raise Exceptions::BuildFailed
      end
    end
  end
end
