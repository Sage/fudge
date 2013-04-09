require 'spec_helper'

class TestBundlerAwareTask
  def self.name
    :test_bundle_aware
  end

  def run(options = {})
    options[:bundler] == true
  end
end

class TestNonBundlerAwareTask

  def self.name
    :test_non_bundle_aware
  end

  def run(options={})
    true
  end
end

describe Fudge::Tasks::CleanBundlerEnv do
  it { should be_registered_as :clean_bundler_env }

  describe :run do
    let(:bundle_aware_task) { TestBundlerAwareTask.new }
    let(:non_bundle_aware_task) { TestNonBundlerAwareTask.new }

    context "with a bundle aware task" do
      it "should run the bundle dependent tasks successfully" do
        subject.tasks << bundle_aware_task
        subject.tasks << non_bundle_aware_task

        subject.run.should be_true
      end

      it "runs each task with a clean bundle env" do
        Bundler.should_receive(:with_clean_env).and_call_original

        subject.tasks << bundle_aware_task
        subject.run.should be_true
      end
    end
  end
end
