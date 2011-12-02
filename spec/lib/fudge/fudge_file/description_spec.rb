require 'spec_helper'
require 'fudge/fudge_file/description'

describe Fudge::FudgeFile::Description do
  describe :build do
    it "should create a new build and add it to the builds array" do
      subject.builds.should be_empty

      subject.build :some_branch do
      end

      subject.builds.should have(1).item
      subject.builds[:some_branch].should be_a Fudge::FudgeFile::Build
    end

    it "should evaluate the block in the context of the build object" do
      subject.build :default do
        @foo = :bar
      end

      subject.builds[:default].instance_variable_get(:@foo).should == :bar
    end
  end

  describe :run_build do
  end
end
