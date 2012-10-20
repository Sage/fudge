# This class has a comment
class BadStyled
  # We all love a bit of trailing whitespace 
  def long_method(lines)
    lines.map {|l| l.downcase }.join(':') + 'This is the rest of the message I want add'
  end

end
