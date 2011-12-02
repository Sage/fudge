require 'fudge/fudge_file/parser'

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
          Fudge::FudgeFile::Parser.new.parse('Fudgefile')
        end
      end
    end
  end
end
