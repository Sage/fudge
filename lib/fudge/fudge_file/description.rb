require 'fudge/fudge_file/build'

module Fudge
  module FudgeFile
    # A class that represents a FudgeFile definition in Ruby class form.
    #
    class Description
      attr_reader :builds

      # Sets builds to an initial empty array
      def initialize
        @builds = []
      end

      # Adds a build to the current description
      def build(&block)
        @builds << Build.new.tap do |b|
          b.instance_eval(&block)
        end
      end
    end
  end
end
