module Fudge
  class Runner
    def initialize(description)
      @description = description
    end

    def run_build(which_build='default')
      which_build = String.new(which_build)

      puts "Running build ".foreground(:cyan) + which_build.bright.foreground(:yellow)

      # Run the build
      status = @description.builds[which_build.to_sym].run

      # Output status
      if status
        puts "Build SUCCEEDED!".foreground(:green).bright
      else
        raise Exceptions::BuildFailed
      end
    end
  end
end
