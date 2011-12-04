class DummyTask
  class << self
    attr_accessor :ran
  end

  def self.name
    :dummy
  end

  def run
    self.class.ran = true
  end
end
Fudge::FudgeFile::TaskRegistry.register(DummyTask)

RSpec.configure do |c|
  c.after :each do
    DummyTask.ran = false
  end
end
