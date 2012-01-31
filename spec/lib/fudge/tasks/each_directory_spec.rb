require 'spec_helper'

class TestEachDirectoryTask
  attr_accessor :pwds
  def self.name
    :test_each_directory
  end

  def run
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
    it "should change to the given directories and run child tasks" do
      subject.task :test_each_directory

      subject.run

      dirs = Dir[File.expand_path('../../../../*', __FILE__)].select { |path| File.directory? path }
      subject.tasks.first.pwds.should == dirs
    end
  end
end
