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
  end
end
