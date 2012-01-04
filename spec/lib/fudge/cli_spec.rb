require 'spec_helper'

describe Fudge::Cli do
  use_tmp_dir

  describe :build do
    before :each do
      File.open('Fudgefile', 'w') do |f|
        f.write("build :default do |b|\n\tb.task :dummy\nend")
      end
    end

    it "run the default build" do
      subject.build
      DummyTask.ran.should be_true
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
        f.read.should include "build :default do |b|\n  b.task :rspec\nend"
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

  describe :install do
    it "should create the root directory and add the db" do
      Fudge::Config.root_directory = './test_root'
      File.should_not be_exists('./test_root')

      subject.install

      File.should be_exists('./test_root')

      lambda { Fudge::Models::Project.all }.should_not raise_error
    end
  end

  describe :add do
    it "should add a project to the database" do
      Fudge::Models::Project.delete_all

      subject.add('foo')

      Fudge::Models::Project.count.should == 1
      Fudge::Models::Project.first.name.should == 'foo'
    end
  end

  describe :server do
    it "should start the sinatra app" do
      Fudge::Server.should_receive(:run!)

      subject.server
    end
  end
end
