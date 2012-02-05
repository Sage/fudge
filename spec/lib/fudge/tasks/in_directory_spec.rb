require 'spec_helper'

class TestInDirectoryTask
  attr_accessor :pwd
  def self.name
    :test_in_directory
  end

  def run
    self.pwd = FileUtils.pwd
  end
end
Fudge::Tasks.register(TestInDirectoryTask)

describe Fudge::Tasks::InDirectory do
  subject { described_class.new 'spec' }
  it { should be_registered_as :in_directory }

  describe :initialize do
    it "should take a directory as first argument" do
      expect { described_class.new }.to raise_error ArgumentError
    end
  end

  describe :run do
    it "should change to the given directory and run child tasks" do
      subject.task :test_in_directory

      subject.run

      subject.tasks.first[0].pwd.should == File.expand_path('spec', FileUtils.pwd)
    end
  end
end
