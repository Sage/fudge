require 'thor'

module Fudge
  class Cli < Thor
    desc "init", "Initialize a blank Fudgefile"
    def init
      path = File.expand_path('Fudgefile', Dir.pwd)

      if File.exists?(path)
        puts "Fudgefile already exists."
      else
        contents = <<RUBY
build :default do |b|
  b.task :rspec
end
RUBY
        File.open(path, 'w') { |f| f.write(contents) }
        puts "Fudgefile created."
      end
    end

    desc "build [BUILD_NAME]", "Run a build with the given name (default: 'default')"
    method_option :callbacks, :type => :boolean, :default => false
    def build(build_name='default')
      description = Fudge::Parser.new.parse('Fudgefile')
      Fudge::Runner.new(description).run_build(build_name, options)
    end
  end
end
