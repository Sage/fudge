module Fudge
  class Config
    class << self
      attr_accessor :root_directory

      def relative_path(path)
        File.expand_path(path.gsub(/[^0-9a-zA-Z_\/.]/, '_'), root_directory)
      end

      def ensure_root_directory!
        FileUtils.mkdir_p(root_directory)
      end
    end
    self.root_directory = File.expand_path('~/.fudge')
  end
end
