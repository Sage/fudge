require 'spec_helper'
require 'ostruct'

describe Fudge::Models::Project do
  before(:all) { FakeFS.activate! }
  after(:all) { FakeFS.deactivate! }

  subject { Fudge::Models::Project.new 'project1', 'git@github.com:whilefalse/tools.git' }

  describe :initialize do
    it "should require a name" do
      lambda { Fudge::Models::Project.new }.should raise_error ArgumentError
    end

    it "should set the name attribute to the first argument" do
      Fudge::Models::Project.new('bla', 'git@github.com:whilefalse/tools.git').name.should == 'bla'
    end

    it "should set the path attribute to the correct path" do
      Fudge::Config.root_directory = '/bla'
      Fudge::Models::Project.new('bla', 'git@github.com:whilefalse/tools.git').path.should == '/bla/bla'
    end

    it "should set the origin attribute to the given origin" do
      Fudge::Models::Project.new('bla', 'git@github.com:whilefalse/tools.git').origin.should == 'git@github.com:whilefalse/tools.git'
    end
  end

  describe :save! do
    before :each do
      FakeFS::FileSystem.clear
      Fudge::Config.root_directory = File.expand_path('~/.fudge')
      Fudge::Config.ensure_root_directory!
      Git.stub(:clone)
    end

    it "should create a directory if it doesn't exist" do
      subject.save!

      File.directory?(File.expand_path('~/.fudge/project1')).should be_true
    end

    it "should create a builds/ directory underneath the project path" do
      subject.save!

      File.directory?(File.expand_path('~/.fudge/project1/builds')).should be_true
    end

    it "should create a new git clone" do
      Git.should_receive(:clone).with('git@github.com:whilefalse/tools.git', File.expand_path('~/.fudge/project1/source'))

      subject.save!
    end

    it "should write a yaml file" do
      subject.save!

      File.exists?(File.expand_path('~/.fudge/project1/project.yml')).should be_true
    end
  end

  describe :load do
    before :each do
      FakeFS::FileSystem.clear
      Fudge::Config.root_directory = File.expand_path('~/.fudge')
      Fudge::Config.ensure_root_directory!
      Git.stub(:clone)
      subject.save!
    end

    it "should load the project from the given path" do
      loaded = Fudge::Models::Project.load(File.expand_path('~/.fudge/project1/project.yml'))
      loaded.name.should == 'project1'
    end
  end

  describe :load_by_name do
    it "should call load with a path generated from the name" do
      Fudge::Models::Project.should_receive(:load).with(File.expand_path('~/.fudge/project1/project.yml'))

      Fudge::Models::Project.load_by_name('project1')
    end
  end

  describe :all do
    it "should return a project instance for each project directory" do
      clear_filesystem
      build_project
      build_project('project2')

      Fudge::Models::Project.all.should have(2).items
      Fudge::Models::Project.all.first.name.should == 'project1'
      Fudge::Models::Project.all[1].name.should == 'project2'
    end
  end

  describe :builds do
    it "should return an entry for each build" do
      build_project_and_builds

      @project.builds.should have(2).items
    end
  end

  describe :next_build_number do
    it "should return the last build number plus one" do
      build_project_and_builds

      @project.next_build_number.should == 11
    end

    it "should return 1 when there are no previous builds" do
      clear_filesystem
      build_project

      @project.next_build_number.should == 1
    end
  end

  describe :next_build do
    it "should create new build with the next build number and the given project" do
      build_project_and_builds

      mock_build = mock(Fudge::Models::Build)
      Fudge::Models::Build.should_receive(:new).with(@project, 11).and_return(mock_build)

      mock_build.should_receive(:status=).with(:queued)
      mock_build.should_receive(:save!)

      @project.next_build
    end
  end

  describe :update! do
    it "should call reset_hard then pull" do
      build_project_and_builds

      Git.stub(:open).and_return(Git::Base.new)

      Git::Base.any_instance.should_receive(:reset_hard)
      Git::Base.any_instance.should_receive(:fetch)
      Git::Base.any_instance.should_receive(:diff).and_return(OpenStruct.new(:patch => 'diff'))
      Git::Base.any_instance.should_receive(:merge)

      @project.update!
    end
  end

  describe :status do
    it "should return the status of the last build" do
      build_project_and_builds

      build = Fudge::Models::Build.new(@project, 11)
      build.status = :bla
      build.save!

      @project.status.should == :bla
    end

    it "should return :no_builds when there have been no builds yet" do
      clear_filesystem
      build_project

      @project.status.should == :no_builds
    end
  end
end
