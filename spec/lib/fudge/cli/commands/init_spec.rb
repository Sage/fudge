require 'spec_helper'

describe Fudge::Cli::Commands::Init do
  use_tmp_dir
  it_should_behave_like "a cli command"

  describe :run do
    it "should create a new FudgeFile in the current directory" do
      File.should_not be_exists('Fudgefile')

      subject.run

      File.should be_exists('Fudgefile')
    end

    it "should contain a default build" do
      subject.run

      File.open('Fudgefile', 'r') do |f|
        f.read.should include "build :default do\nend"
      end
    end

    it "should not modify the Fudgefile if one exists" do
      File.open('Fudgefile', 'w') do |f|
        f.write('foo')
      end

      subject.run

      File.open('Fudgefile') { |f| f.read }.should == 'foo'
    end
  end
end
