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

        def run
          if File.exists?(File.expand_path('Fudgefile', Dir.pwd))
            puts "Fudgefile already exists."
          else
            FileUtils.cp(File.expand_path('../../templates/Fudgefile', __FILE__), Dir.pwd)
            puts "Fudgefile created."
          end
        end
      end
    end
  end
end
