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
          Fudge::FudgeFile::Utils::CommandRunner.new.run(
            "rake #{@cmd}"
          )
          return $?.success?
        end
      end
      TaskRegistry.register(Rake)
    end
  end
end
