require 'spec_helper'
require 'fudge/fudge_file/runner'

describe Fudge::FudgeFile::Runner do
  describe :run_build do
    it "should run the default task in the description" do
      description = Fudge::FudgeFile::Description.new do
        build :default do
          task :dummy
        end
      end

      described_class.new(description).run_build
      DummyTask.ran.should be_true
    end
  end
end
