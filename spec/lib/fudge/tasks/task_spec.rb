require 'spec_helper'

class MyTask < Fudge::Tasks::Task
  attr_accessor :blabla
end

describe Fudge::Tasks::Task do
  describe :initialize do
    it "should accepts options and set them" do
      task = MyTask.new :blabla => 'foo'
      task.blabla.should == 'foo'
    end
  end
end
