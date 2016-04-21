require 'spec_helper'

class TestInDirectoryTask
  attr_accessor :pwd
  def self.name
    :test_in_directory
  end

  def run(_options = {})
    self.pwd = FileUtils.pwd
  end
end
Fudge::Tasks.register(TestInDirectoryTask)

describe Fudge::Tasks::InDirectory do
  subject { described_class.new 'spec' }
  it { is_expected.to be_registered_as :in_directory }

  describe '#initialize' do
    it 'should take a directory as first argument' do
      expect { described_class.new }.to raise_error ArgumentError
    end
  end

  describe '#run' do
    let(:task) { TestInDirectoryTask.new }
    let(:path) { File.expand_path('spec', FileUtils.pwd) }

    before :each do
      subject.tasks << task
    end

    it 'should change to the given directory and run child tasks' do
      subject.run

      expect(task.pwd).to eq(path)
    end
  end
end
