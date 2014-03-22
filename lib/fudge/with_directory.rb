#Directory helpers methods
class Fudge::WithDirectory
  attr_reader :dir, :formatter

  def initialize(dir, formatter)
    @dir = dir
    @formatter = formatter
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
    formatter.write { |w| w.info('--> In directory').notice(dir) }
  end
end
