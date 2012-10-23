require 'spec_helper'

class MyTask < Fudge::Tasks::Task
  attr_accessor :blabla
end

class TestNamespace
  class SomeTask < Fudge::Tasks::Task
  end
end

describe Fudge::Tasks::Task do
  describe :initialize do
    it "should accepts options and set them" do
      task = MyTask.new :blabla => 'foo'

      task.blabla.should == 'foo'
    end
  end

  describe :name do
    it "should default to implied name from class name" do
      TestNamespace::SomeTask.name.should == :some_task
    end
  end
end
