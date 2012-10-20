# This class has a comment
class TheLitteClassThatCan
  # Nice Code
  def well_facored(code)
    code.each do |c|
      perform_action(c)
    end
  end

  private

  def perform_action(snippet)
    snippet.call(self)
  end

end
