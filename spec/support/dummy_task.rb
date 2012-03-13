class DummyTask < Fudge::Tasks::Task
  class << self
    attr_accessor :ran
  end
  attr_accessor :args

  def self.name
    :dummy
  end

  def initialize(*args)
    super
    self.args = args
  end

  def run(options={})
    self.class.ran = true
  end
end
Fudge::Tasks.register(DummyTask)

class DummyCompositeTask < Fudge::Tasks::CompositeTask
  attr_accessor :args

  def initialize(*args)
    super
    self.args = args
  end

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
