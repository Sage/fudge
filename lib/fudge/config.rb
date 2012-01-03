module Fudge
  class Config
    class << self
      attr_writer :root_directory, :database

      def relative_path(path)
        File.expand_path(path.gsub(/[^0-9a-zA-Z_\/.]/, '_'), root_directory)
      end

      def ensure_root_directory!
        FileUtils.mkdir_p(root_directory)
      end

      def root_directory
        @root_directory ||= File.expand_path('~/.fudge')
      end

      def database
        @database ||= {
          :adapter => "sqlite3",
          :database => "#{root_directory}/fudge.sqlite3"
        }
      end
    end
  end
end
