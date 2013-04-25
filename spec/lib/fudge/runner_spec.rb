require 'spec_helper'

describe Fudge::Runner do
  let(:input) do
    StringIO.new('build :default do; task :dummy; end').tap do |s|
      s.stub(:path).and_return('')
    end
  end
  let(:description) { Fudge::Description.new(input) }
  subject { described_class.new(description) }

  describe :run_build do
    it "should run the default task in the description" do
      subject.run_build

      DummyTask.ran.should be_true
    end

    it "should raise an exception if the build fails" do
      Fudge::Build.any_instance.stub(:run).and_return(false)

      expect { subject.run_build }.to raise_error Fudge::Exceptions::BuildFailed
    end

    context "when an output is provided" do
      let(:output) { StringIO.new }

      before :each do
        subject.run_build 'default', :output => output
      end

      it "puts all output to given output instead stdout" do
        output.string.should_not be_empty
        output.string.should include "Running build"
        output.string.should include "default"
        output.string.should include "Build SUCCEEDED!"
      end

      it "runs the task passing the output down" do
        DummyTask.run_options.should == {:output => output}
      end
    end
  end
end
