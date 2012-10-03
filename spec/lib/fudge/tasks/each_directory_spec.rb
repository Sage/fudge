require 'spec_helper'

class TestEachDirectoryTask
  attr_accessor :pwds
  def self.name
    :test_each_directory
  end

  def run(options={})
    (self.pwds ||= []) << FileUtils.pwd
  end
end
Fudge::Tasks.register(TestEachDirectoryTask)

describe Fudge::Tasks::EachDirectory do
  subject { described_class.new 'spec/*' }
  it { should be_registered_as :each_directory }

  describe :initialize do
    it "should take a directory pattern as first argument" do
      expect { described_class.new }.to raise_error ArgumentError
    end
  end

  describe :run do
    let(:task) { TestEachDirectoryTask.new }
    let(:dirs) do
      Dir[File.expand_path('../../../../*', __FILE__)].select { |path| File.directory? path }
    end

    before :each do
      subject.tasks << task
    end

    it "should change to the given directories and run child tasks" do
      subject.run

      task.pwds.should == dirs
    end

    it "should allow explicit specification of directories through an array" do
      ed2 = described_class.new ["spec/lib","spec/support"]
      ed2.tasks << task
      ed2.run
      task.pwds.should == dirs.sort
    end

    it "should respect the order of the directories as specified" do
      ed2 = described_class.new ["spec/support","spec/lib"]
      ed2.tasks << task
      ed2.run
      task.pwds.should_not == dirs.sort
      task.pwds.sort.should == dirs.sort
    end

  end
end
