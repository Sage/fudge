#Directory helpers methods
class Fudge::WithDirectory
  attr_reader :dir, :output

  def initialize(dir, output)
    @dir = dir
    @output = output
  end

  # Executes a block inside the directory
  def inside
    Dir.chdir(dir) do
      output_message
      yield
    end
  end

  private

  def output_message
    message = %Q(#{'--> In directory'.foreground(:cyan)} #{"#{dir}:".foreground(:cyan).bright})
    output.puts message
  end
end
