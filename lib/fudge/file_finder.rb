module Fudge
  # Allows building of commands which run against a set of files
  class FileFinder
    attr_reader :options

    def initialize(options = {})
      @options = options
    end

    # Generates a command line with command and any tty_option
    def generate_command(name, tty_options)
      cmd = []
      cmd << name
      cmd += tty_options
      cmd << "`#{find_filters.join(' | ')}`"
      cmd.join(' ')
    end

    private

    def find_filters
      filters = []
      filters << 'find .'
      filters << "grep -e '\\.rb$'"
      filters << exclude_filter
      filters.compact
    end

    def exclude_filter
      if (pattern = options[:exclude])
        "grep -v -e '#{pattern}'"
      end
    end
  end
end
