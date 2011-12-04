require 'fudge/fudge_file/build'

module Fudge
  module FudgeFile
    # A class that represents a FudgeFile definition in Ruby class form.
    #
    class Description
      attr_reader :builds

      # Sets builds to an initial empty array
      def initialize(fudge_file_contents)
        @builds = {}
        eval(fudge_file_contents)
      end

      # Adds a build to the current description
      def build(name, &block)
        @builds[name] = Build.new(&block)
      end
    end
  end
end
