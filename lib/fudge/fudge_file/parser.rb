require 'fudge/fudge_file/description'

module Fudge
  module FudgeFile
    # Handles parsing of fudge file and building the necessary description
    #
    class Parser
      # Parse a FudgeFile at a given location
      def parse(file)
        contents = File.open(file) { |f| f.read }
        evaluate(contents)
      end

      #Evaluates a string read from a FudgeFile
      def evaluate(string)
        Description.new.tap do |d|
          d.instance_eval(string)
        end
      end
    end
  end
end
