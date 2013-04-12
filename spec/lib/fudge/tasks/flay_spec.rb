require 'spec_helper'

describe Fudge::Tasks::Flay do
  it { should be_registered_as :flay }

  it_should_behave_like 'bundle aware'


  let(:output_good) do
    <<-EOF
Total score (lower is better) = 0
EOF
  end

  let(:output_bad) do
    <<-EOF
Total score (lower is better) = 100
EOF
  end

  describe :run do
    it "runs flay on the codebase" do
      subject.should run_command "flay --diff `find . | grep -e '\\.rb$'`"
    end

    context 'with :exclude => pattern' do
      subject {described_class.new :exclude => 'spec/'}

      it "filters out the pattern" do
        cmd = "flay --diff `find . | grep -e '\\.rb$' | grep -v -e 'spec/'`"
        subject.should run_command cmd
      end
    end

    it { should_not succeed_with_output output_bad }
    it { should succeed_with_output output_good }

    context 'when :max score is supplied' do
      it 'fails when score is higher than max' do
        task = described_class.new :max => 99
        task.should_not succeed_with_output output_bad

        task = described_class.new :max => 100
        task.should succeed_with_output output_bad
      end
    end
  end
end
