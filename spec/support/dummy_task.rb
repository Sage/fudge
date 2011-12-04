require 'fudge/fudge_file/task_registry'

class DummyTask
  class << self
    attr_accessor :ran
  end

  def run
    self.class.ran = true
  end
end
Fudge::FudgeFile::TaskRegistry.register(:dummy, DummyTask)

RSpec.configure do |c|
  c.after :each do
    DummyTask.ran = false
  end
end
