require 'spec_helper'
require 'fudge/fudge_file/parser'

describe Fudge::FudgeFile::Parser do
  before(:all) { FakeFS.activate! }
  after(:all) { FakeFS.deactivate! }

  describe :parse do
    before :each do
      @path = File.expand_path('FudgeFile', Fudge::Config.root_directory)
      Fudge::Config.ensure_root_directory!
      File.open(@path, 'w') do |f|
        f.write('@foo = :bar')
      end
    end

    it "should read a file and evaluate it" do
      subject.parse(@path).should be_a Fudge::FudgeFile::Description
    end

    it "should pass the contents to the new description" do
      subject.parse(@path).instance_variable_get(:@foo).should == :bar
    end
  end
end
