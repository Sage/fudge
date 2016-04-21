require 'spec_helper'

describe Fudge::Runner do
  let(:input) do
    StringIO.new('build :default do; task :dummy; end').tap do |s|
      allow(s).to receive(:path).and_return('')
    end
  end
  let(:description) { Fudge::Description.new(input) }
  subject { described_class.new(description) }

  describe '#run_build' do
    it 'should run the default task in the description' do
      subject.run_build

      expect(DummyTask.ran).to be_truthy
    end

    it 'should raise an exception if the build fails' do
      allow_any_instance_of(Fudge::Build).to receive(:run).and_return(false)

      expect { subject.run_build }.to raise_error Fudge::Exceptions::BuildFailed
    end

    context 'when an formatter is provided' do
      let(:stdout) { StringIO.new }
      let(:formatter) { Fudge::Formatters::Simple.new(stdout) }

      before :each do
        subject.run_build 'default', formatter: formatter
      end

      it 'puts all output to given formatter instead stdout' do
        expect(stdout.string).not_to be_empty
        expect(stdout.string).to include 'Running build'
        expect(stdout.string).to include 'default'
        expect(stdout.string).to include 'Build SUCCEEDED!'
      end

      it 'runs the task passing the formatter down' do
        expect(DummyTask.run_options).to eq(formatter: formatter)
      end
    end
  end
end
