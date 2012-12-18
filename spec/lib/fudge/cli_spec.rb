require 'spec_helper'

class AnotherDummyTask < DummyTask
  def self.name
    :another_dummy
  end

  def run(options={})
    self.class.ran = true
  end
end
Fudge::Tasks.register(AnotherDummyTask)

describe Fudge::Cli do
  use_tmp_dir

  after :each do
    AnotherDummyTask.ran = false
  end

  describe :build do
    before :each do
      File.open('Fudgefile', 'w') do |f|
        contents = <<-RUBY
          build :default do
            dummy
          end

          build :other do
            another_dummy
          end
        RUBY
        f.write(contents)
      end
    end

    it "should run the default build" do
      subject.build 'default'
      DummyTask.ran.should be_true
    end

    it "should accept a build name to run" do
      subject.build 'other'
      DummyTask.ran.should be_false
      AnotherDummyTask.ran.should be_true
    end
  end

  describe :init do
    it "should create a new FudgeFile in the current directory" do
      File.should_not be_exists('Fudgefile')

      subject.init

      File.should be_exists('Fudgefile')
    end

    it "should contain a default build" do
      subject.init

      File.open('Fudgefile', 'r') do |f|
        f.read.should eql "build :default do\n  task :rspec\nend"
      end
    end

    it "should not modify the Fudgefile if one exists" do
      File.open('Fudgefile', 'w') do |f|
        f.write('foo')
      end

      subject.init

      File.open('Fudgefile') { |f| f.read }.should == 'foo'
    end
  end
end
