module Fudge
  module FudgeFile
    class Runner
      def initialize(description)
        @description = description
      end

      def run_build
        @description.builds[:default].run
      end
    end
  end
end
