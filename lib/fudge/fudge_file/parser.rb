module Fudge
  module FudgeFile
    # Handles parsing of fudge file and building the necessary description
    #
    class Parser
      # Parse a FudgeFile at a given location
      def parse(file)
        contents = File.open(file) { |f| f.read }
        Description.new(contents)
      end
    end
  end
end
