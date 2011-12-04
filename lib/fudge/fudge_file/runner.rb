module Fudge
  module FudgeFile
    class Runner
      def initialize(description)
        @description = description
      end

      def run_build
        which_build = :default
        puts "Running build ".foreground(:cyan) + which_build.to_s.bright.foreground(:cyan) + '...'.foreground(:cyan)

        # Run the build
        status = @description.builds[which_build].run

        if status
          puts "Build SUCCEEDED!".foreground(:green).bright
        else
          puts "Build FAILED!".foreground(:red).bright
        end
      end
    end
  end
end
