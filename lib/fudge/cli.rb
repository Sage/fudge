require 'thor'

module Fudge
  # Fudge command line interface
  class Cli < Thor
    desc "init", "Initialize a blank Fudgefile"
    # Initalizes the blank Fudgefile
    def init
      generator = Fudge::Generator.new(Dir.pwd)
      generator.write_fudgefile
    end

    desc "build [BUILD_NAME]",
      "Run a build with the given name (default: 'default')"
    method_option :callbacks, :type => :boolean, :default => false
    # Runs the parsed builds
    # @param [String] build_name the given build to run (default 'default')
    def build(build_name='default')
      description = Fudge::Parser.new.parse('Fudgefile')
      Fudge::Runner.new(description).run_build(build_name, options)
    end
  end
end
