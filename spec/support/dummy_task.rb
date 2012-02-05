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
Fudge::Tasks.register(DummyTask)

class DummyCompositeTask < Fudge::Tasks::CompositeTask
  def self.name
    :dummy_composite
  end
end
Fudge::Tasks.register(DummyCompositeTask)

RSpec.configure do |c|
  c.after :each do
    DummyTask.ran = false
  end
end
