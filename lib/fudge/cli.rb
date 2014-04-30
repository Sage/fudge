require 'thor'

module Fudge
  # Fudge command line interface
  class Cli < Thor
    desc "init", "Initialize a blank Fudgefile"
    # Initalizes the blank Fudgefile
    def init
      generator = Fudge::Generator.new(Dir.pwd)
      msg = generator.write_fudgefile
      shell.say msg
    end

    desc "build [BUILD_NAME]",
      "Run a build with the given name (default: 'default')"
    method_option :callbacks, :type => :boolean, :default => false
    method_option :time, :type => :boolean, :default => false
    # Runs the parsed builds
    # @param [String] build_name the given build to run (default 'default')
    def build(build_name='default')
      description = Fudge::Parser.new.parse('Fudgefile')
      Fudge::Runner.new(description).run_build(build_name, options)
    end

    desc "list [FILTER]",
      "List all builds defined in the Fudgefile that match FILTER (default: list all)"
    # Lists builds defined in Fudgefile, with optional filtering.
    #
    # If given no filter, all builds are listed.  If given a filter,
    # lists builds whose names match the filter.  Matching is based on
    # sub-string matching and is case insensitive.
    #
    # The listing includes the build name, followed by the about
    # string if one was specified in the Fudgefile.
    #
    # @param [String] filter  a string by which to filter the builds listed
    def list(filter="")
      description = Fudge::Parser.new.parse('Fudgefile')
      builds = description.builds.map { |name, build| ["#{name}", build.about] }
      matches = builds.select { |name, _| name =~ /#{filter}/i }
      shell.print_table(matches, :indent => 2, :truncate => true)
    end
  end
end
