require 'spec_helper'

describe Fudge::Config do
  before(:all) { FakeFS.activate! }
  after(:all) { FakeFS.deactivate! }

  describe :root_directory do
    it "should default to the current user's home directory with .fudge added" do
      Fudge::Config.root_directory.should == File.expand_path('~/.fudge')
    end

    it "should allow setting of the root_directory" do
      Fudge::Config.root_directory = 'foo'
      Fudge::Config.root_directory.should == 'foo'
    end
  end

  describe :relative_path do
    it "should return the root_directory with the argument added" do
      Fudge::Config.root_directory = '/fudge'
      Fudge::Config.relative_path('foo/bar').should == '/fudge/foo/bar'
    end

    it "should replace special characters by underscores" do
      Fudge::Config.relative_path("hello_'!@?:.,_58454").should == '/fudge/hello______.__58454'
    end
  end

  describe :ensure_root_directory! do
    it "should create the directory if it doesn't exist" do
      FakeFS::FileSystem.clear
      Fudge::Config.root_directory = 'foo'

      Fudge::Config.ensure_root_directory!

      File.directory?('foo').should be_true
    end
  end

  describe :database do
    it "should default to a sqlite3 file in the root directory" do
      Fudge::Config.root_directory = '/foo'

      Fudge::Config.database.should == {
          :adapter => "sqlite3",
          :database => '/foo/fudge.sqlite3'
      }
    end
  end
end
