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
        f.write('foo')
      end
    end

    it "should read a file and evaluate it" do
      subject.should_receive(:evaluate).with('foo')
      subject.parse(@path)
    end
  end

  describe :evaluate do
    it "should return a new description" do
      subject.evaluate('').should be_a Fudge::FudgeFile::Description
    end

    it "should evaluate the contents in the new description" do
      subject.evaluate('@foo = :bar').instance_variable_get(:@foo).should == :bar
    end
  end
end
