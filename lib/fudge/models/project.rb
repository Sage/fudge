module Fudge
  module Models
    class Project < ActiveRecord::Base
      attr_accessor :name, :path, :origin, :diff

      def initialize(name, origin)
        self.name = name
        self.path = Fudge::Config.relative_path(name)
        self.origin = origin
      end

      def save!
        FileUtils.mkdir(path)
        FileUtils.mkdir(File.expand_path('builds', path))
        File.open(File.expand_path('project.yml', path), 'w') do |f|
          ::YAML.dump(self, f)
        end
        Git.clone(origin, File.expand_path('source', path))
      end

      def self.load_by_name(name)
        self.load Fudge::Config::relative_path("#{name}/project.yml")
      end

      def self.load(path)
        ::YAML.load_file(path)
      end

      def self.all
        Dir[Fudge::Config.root_directory + '/**/project.yml'].map do |x|
          self.load x
        end
      end

      def builds
        Dir[path + "/**/build.yml"].map do |x|
          Build.load(x)
        end.sort_by(&:number).reverse
      end

      def next_build_number
        last_build ? (last_build.number + 1) : 1
      end

      def status
        last_build ? last_build.status : :no_builds
      end

      def update!
        git.reset_hard
        git.fetch('origin')
        self.diff = git.diff('origin/master', 'HEAD').patch
        git.merge('origin/master')
      end

      def next_build
        build = Build.new(self, next_build_number)
        build.status = :queued
        build.save!
        build
      end

      def latest_commit
        Git::Object::Commit.new(git, 'HEAD')
      end

      private
      def git
        @git || Git.open(File.expand_path('source', path))
      end

      def last_build
        builds.max_by &:number
      end
    end
  end
end
