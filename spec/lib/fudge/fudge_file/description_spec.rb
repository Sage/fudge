require 'spec_helper'
require 'fudge/fudge_file/description'

describe Fudge::FudgeFile::Description do
  subject { described_class.new '' }

  describe :initialize do
    it "should add the builds in the given string" do
      desc = described_class.new "build :foo do; end"

      desc.builds[:foo].should be_a Fudge::FudgeFile::Build
    end
  end

  describe :build do
    it "should create a new build and add it to the builds array" do
      subject.builds.should be_empty

      subject.build :some_branch do
      end

      subject.builds.should have(1).item
      subject.builds[:some_branch].should be_a Fudge::FudgeFile::Build
    end

    it "should pass the block to the build object" do
      build = nil
      subject.build :default do |b|
        build = b
      end

      subject.builds[:default].should == build
    end
  end
end
