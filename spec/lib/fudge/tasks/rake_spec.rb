require 'spec_helper'

describe Fudge::Tasks::Rake do
  it { is_expected.to be_registered_as :rake }
  it { is_expected.to be_a Fudge::Tasks::Shell }

  describe '#run' do
    it 'should be rake by default' do
      expect(subject).to run_command 'rake '
    end

    it_should_behave_like 'bundle aware'

    it 'should add any arguments given' do
      expect(described_class.new('db:migrate')).to run_command 'rake db:migrate'
    end
  end
end
