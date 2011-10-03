require 'yaml'
require 'cgi'

module Fudge
  module Models
    class Build
      attr_accessor :project, :number, :commit, :status, :diff, :path

      def initialize(project, number)
        self.project = project
        self.number = number
        self.path = File.expand_path("builds/#{number}", project.path)
      end

      def save!
        FileUtils.mkdir_p(path)
        File.open(File.expand_path('build.yml', path), 'w') do |f|
          ::YAML.dump(self, f)
        end
      end

      def self.load(path)
        ::YAML.load_file(path)
      end

      def build!
        status = system("cd #{project.path}/source && ls > #{path}/output.txt 2>&1")
        self.status = status ? :success : :failure
        self.save!
      end

      def html_diff
        ansi_color_codes(diff)
      end

      def ansi_color_codes(string)
        CGI::escapeHTML(string).gsub(/\e\[(\d+)m(.*?)\e\[m/, "<span class=\"color\\1\">\\2</span>").gsub(/\e\[m/, '').gsub("\n", "<br/>")
      end

      def output
        File.open(File.expand_path('output.txt', path), 'r') { |f| ansi_color_codes(f.read) }
      end
    end
  end
end
