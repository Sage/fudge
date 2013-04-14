module Fudge
  #Generator for default Fudgefile
  class Generator
    attr_reader :pwd

    def initialize(pwd)
      @pwd = pwd
    end

    #Writes the fudgefile to initialized directory unless on present
    def write_fudgefile
      if exists?
        puts "Fudgefile already exists."
      else
        writer { |file| file << build_templated }
        puts "Fudgefile created."
      end
    end

    private

    def writer
      File.open(path, 'w') { |f| yield f }
    end

    def path
      @path ||= File.expand_path('Fudgefile', pwd)
    end

    def exists?
      File.exists?(path)
    end

    def build_templated
      contents = ""
      contents << "build :default do\n"
      contents << "  task :rspec\n"
      contents << "end"
    end

  end
end
