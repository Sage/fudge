module Fudge
  module Cli
    module Commands
      # CLI task for initializing a FudgeFile
      class Init
        def self.command
          :init
        end
        def self.description
          "Initialize a new FudgeFile in your project"
        end

        # Runs the command
        def run
          unless File.exists?(File.expand_path('Fudgefile', Dir.pwd))
            FileUtils.cp(File.expand_path('../../templates/Fudgefile', __FILE__), Dir.pwd)
          end
        end
      end
    end
  end
end
