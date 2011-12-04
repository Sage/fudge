require 'fudge/fudge_file'

module Fudge
  module Cli
    module Commands
      class Build
        def self.command
          :build
        end
        def self.description
          'Run a build'
        end

        def run
          description = Fudge::FudgeFile::Parser.new.parse('Fudgefile')
          Fudge::FudgeFile::Runner.new(description).run_build
        end
      end
    end
  end
end
