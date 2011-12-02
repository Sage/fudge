require 'spec_helper'
require 'fudge/fudge_file/build'

describe Fudge::FudgeFile::Build do
  describe :task do
    it "should add a task to the tasks array" do
      subject.tasks.should be_empty

      subject.task :foo

      subject.tasks.should have(1).item
    end
  end
end
