require 'spec_helper'

describe Fudge::Runner do
  describe :run_build do
    it "should run the default task in the description" do
      description = Fudge::Description.new('build :default do; task :dummy; end')

      described_class.new(description).run_build
      DummyTask.ran.should be_true
    end

    it "should support the old yielding syntax" do
      description = Fudge::Description.new('build :default do |b|; b.task :dummy; end')

      described_class.new(description).run_build
      DummyTask.ran.should be_true
    end

    it "should raise an exception if the build fails" do
      description = Fudge::Description.new('build :default do; task :dummy; end')
      Fudge::Build.any_instance.stub(:run).and_return(false)

      expect { described_class.new(description).run_build }.to raise_error Fudge::Exceptions::BuildFailed
    end
  end
end
