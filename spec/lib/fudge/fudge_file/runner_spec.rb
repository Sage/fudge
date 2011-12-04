require 'spec_helper'
require 'fudge/fudge_file/runner'
require 'fudge/fudge_file/description'

describe Fudge::FudgeFile::Runner do
  describe :run_build do
    it "should run the default task in the description" do
      description = Fudge::FudgeFile::Description.new('build :default do |b|; b.task :dummy; end')

      subject = described_class.new(description)
      subject.stub(:puts)

      subject.run_build
      DummyTask.ran.should be_true
    end
  end
end
