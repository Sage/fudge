#Task Output Checker
class Fudge::OutputChecker
  attr_reader :checker, :regex, :pass_block, :match, :formatter

  def initialize(checker, formatter)
    @checker = checker
    @formatter = formatter
  end

  #Validates output against initialized checker
  def check(output)
    return true unless checker # We're ok if no output defined
    extract_matchers
    matches?(output) && block_passes?
  end

  private

  def block_passes?
    return true unless pass_block

    # If we've got a callable, call it to check on regex matches
    result = pass_block.call(match)
    if success?(result)
      true
    else
      formatter.write {|w| w.error(error_message(result)) }
    end
  end

  def success?(result)
    result === true
  end

  def error_message(result)
    result || "Output matched #{@regex} but condition failed."
  end

  def extract_matchers
    # Check if we have a callable to parse the regex matches
    if checker.is_a? Enumerable
      @regex, @pass_block = checker
    else
      @regex = checker
    end
  end

  def matches?(output)
    # Do regex match and fail if no match
    return true if (@match = output.match(regex))
    formatter.write { |w| w.error( "Output didn't match #{regex}.") }
  end

end
