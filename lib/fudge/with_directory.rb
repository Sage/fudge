#Directory helpers methods
class Fudge::WithDirectory
  attr_reader :dir

  def initialize(dir)
    @dir = dir
  end

  #Ouputs message for a directory
  def output
    message = ""
    message << "--> In directory".foreground(:cyan)
    message << " #{dir}:".foreground(:cyan).bright

    puts message
  end
end
