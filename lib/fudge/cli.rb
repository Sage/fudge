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

    desc "build", "Run a build"
    def build
      description = Fudge::FudgeFile::Parser.new.parse('Fudgefile')
      Fudge::FudgeFile::Runner.new(description).run_build
    end

    desc "install", "Installs the root directory and database for Fudge"
    def install
      if File.exists?(Fudge::Config.root_directory)
        puts "Fudge already installed"
      else
        Fudge::Config.ensure_root_directory!
        require 'fudge/models'
        require 'fudge/schema'

        puts "Installed."
      end
    end

    desc "add NAME", "Adds a project to the Fudge server"
    def add(name)
      Fudge::Models::Project.create(:name => name)
      puts "#{name} added."
    end

    desc "server", "Runs the Fudge server"
    def server
      Fudge::Server.run!
    end
  end
end
