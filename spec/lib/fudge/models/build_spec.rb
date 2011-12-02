require 'spec_helper'
require 'fudge/models/build'

describe Fudge::Models::Build do
  before(:all) { FakeFS.activate! }
  after(:all) { FakeFS.deactivate! }

  let(:project) { Fudge::Models::Project.new('aproject', 'git@github.com:whilefalse/tools.git') }
  subject { Fudge::Models::Build.new(project, 10) }

  describe :attributes do
    it { should respond_to :project }
    it { should respond_to :number }
    it { should respond_to :commit }
    it { should respond_to :status }
    it { should respond_to :diff }
  end

  describe :initialize do
    it "should require a project" do
      lambda { Fudge::Models::Build.new }.should raise_error ArgumentError
    end

    it "should set the project in the project attribute" do
      Fudge::Models::Build.new(project, 1).project.should == project
    end

    it "should require a build number" do
      lambda { Fudge::Models::Build.new(project) }.should raise_error ArgumentError
    end

    it "should set the build number in the number attribute" do
      Fudge::Models::Build.new(project, 10).number.should == 10
    end
  end

  describe :save! do
    it "should write a yaml file under the project directory with the given build number" do
      clear_filesystem
      Git.stub(:clone)
      project.save!
      Fudge::Models::Build.new(project, 11).save!

      File.exists?(File.expand_path('aproject/builds/11/build.yml', Fudge::Config.root_directory)).should be_true
    end
  end

  describe :load do
    before :each do
      FakeFS::FileSystem.clear
      Fudge::Config.ensure_root_directory!
      Git.stub(:clone)
      project.save!
    end

    it "should load the build from the given path" do
      Fudge::Models::Build.new(project, 11).save!

      loaded = Fudge::Models::Build.load(Fudge::Config.relative_path('aproject/builds/11/build.yml'))
      loaded.project.name.should == 'aproject'
      loaded.number.should == 11
    end
  end

  describe :build! do
    before :each do
      clear_filesystem
      Git.stub(:clone)
      project.stub(:latest_commit).and_return('commit')
      project.stub(:diff).and_return('diff')
      project.stub(:update!)
      project.save!
    end

    it "should run 'rake fudge' in the source directory and pipe the output to the build directory" do
      build = Fudge::Models::Build.new(project, 11)
      build.save!

      source_dir = File.expand_path('aproject/source', Fudge::Config::root_directory)
      build_dir = File.expand_path('aproject/builds/11', Fudge::Config::root_directory)

      build.should_receive(:system).with(anything, "cd #{source_dir} && bundle install && bundle exec fudge build > #{build_dir}/output.txt 2>&1")

      build.build!
    end

    it "should set the status to success if the command succeeded" do
      build = Fudge::Models::Build.new(project, 11)
      build.stub(:system).and_return(true)
      build.build!

      build.status.should == :success
    end

    it "should set the status to failure if the command failed" do
      build = Fudge::Models::Build.new(project, 11)
      build.stub(:system).and_return(false)
      build.build!

      build.status.should == :failure
    end
  end

  describe :output do
    it "should return the contents of the output.txt" do
      clear_filesystem

      build = Fudge::Models::Build.new(project, 11)
      build.save!

      File.open(Fudge::Config.relative_path('aproject/builds/11/output.txt'), 'w') do |f|
        f.write('this is some output')
      end

      build.output.should == 'this is some output'
    end
  end
end
