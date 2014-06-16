require 'spec_helper'

class TestEachDirectoryTask
  attr_accessor :pwds
  def self.name
    :test_each_directory
  end

  def run(options={})
    (self.pwds ||= []) << FileUtils.pwd
  end
end
Fudge::Tasks.register(TestEachDirectoryTask)

describe Fudge::Tasks::EachDirectory do
  subject { described_class.new 'spec/*' }
  it { is_expected.to be_registered_as :each_directory }

  describe '#initialize' do
    it "should take a directory pattern as first argument" do
      expect { described_class.new }.to raise_error ArgumentError
    end
  end

  describe '#run' do
    let(:task) { TestEachDirectoryTask.new }
    let(:dirs) do
      files = Dir[File.expand_path('../../../../*', __FILE__)]
      files.select { |path| File.directory? path }
    end

    before :each do
      subject.tasks << task
    end

    it "should change to the given directories and run child tasks" do
      subject.run

      expect(task.pwds).to eq(dirs)
    end

    it "should allow explicit specification of directories through an array" do
      ed2 = described_class.new ["spec/lib","spec/support"]
      ed2.tasks << task
      ed2.run
      expect(task.pwds).to eq(dirs.sort)
    end

    it "should respect the order of the directories as specified" do
      ed2 = described_class.new ["spec/support","spec/lib"]
      ed2.tasks << task
      ed2.run
      expect(task.pwds).not_to eq(dirs.sort)
      expect(task.pwds.sort).to eq(dirs.sort)
    end

    it "should load fudge_settings.yml in the right directory" do
      ed2 = described_class.new ['spec/lib']
      ed2.tasks << Fudge::Tasks::Shell.new('pwd')
      ed2.run
      expect(ed2.tasks.first.options[:test]).to eq('coverage')
    end

    it "should not load fudge_settings.yml in the wrong directory" do
      ed2 = described_class.new ['spec/support']
      ed2.tasks << Fudge::Tasks::Shell.new('pwd')
      ed2.run
      expect(ed2.tasks.first.options.size).to eq(0)
    end
  end
end
