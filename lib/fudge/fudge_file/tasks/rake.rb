module Fudge
  module FudgeFile
    module Tasks
      class Rake
        def self.name
          :rake
        end

        def initialize(cmd)
          @cmd = cmd
        end

        def run
          system("rake #{@cmd}")
        end
      end
      TaskRegistry.register(Rake)
    end
  end
end
