require 'spec_helper'

describe Fudge::FudgeFile::Runner do
  describe :run_build do
    it "should run the default task in the description" do
      description = Fudge::FudgeFile::Description.new('build :default do |b|; b.task :dummy; end')

      described_class.new(description).run_build
      DummyTask.ran.should be_true
    end

    it "should run the default task in the description" do
      description = Fudge::FudgeFile::Description.new('build :default do |b|; b.task :dummy; end')
      Fudge::FudgeFile::Build.any_instance.stub(:run).and_return(false)

      expect { described_class.new(description).run_build }.to raise_error Fudge::Exceptions::Build::BuildFailed
    end
  end
end
