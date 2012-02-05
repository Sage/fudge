module Fudge
  # Handles parsing of fudge file and building the necessary description
  #
  class Parser
    # Parse a FudgeFile at a given location
    def parse(file)
      File.open(file) do |f|
        Description.new(f)
      end
    end
  end
end
