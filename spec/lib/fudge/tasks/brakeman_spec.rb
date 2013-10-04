require 'spec_helper'

describe Fudge::Tasks::Brakeman do
  it { should be_registered_as :brakeman }

  it_should_behave_like 'bundle aware'


  let(:output_good) do
    <<-EOF
| Errors            | 0     |
| Security Warnings | 0 (0) |
+-------------------+-------+

EOF
  end

  let(:output_bad) do
    <<-EOF
| Errors            | 0     |
| Security Warnings | 1 (0) |
+-------------------+-------+

+-----------------+-------+
| Warning Type    | Total |
+-----------------+-------+
| Mass Assignment | 1     |
+-----------------+-------+



Model Warnings:

+------------+---------+-----------------+----------------------------------------------------------------------------+
| Confidence | Model   | Warning Type    | Message                                                                    |
+------------+---------+-----------------+----------------------------------------------------------------------------+
| Weak       | Address | Mass Assignment | Potentially dangerous attribute via_type_id available for mass assignment. |
+------------+---------+-----------------+----------------------------------------------------------------------------+

EOF
  end

  describe :run do
    it 'runs brakeman on the codebase' do
      subject.should run_command 'brakeman '
    end

    it { should_not succeed_with_output output_bad }
    it { should succeed_with_output output_good }

    context 'when :max score is supplied' do
      it 'fails when score is higher than max' do
        task = described_class.new :max => 0
        task.should_not succeed_with_output output_bad

        task = described_class.new :max => 1
        task.should succeed_with_output output_bad
      end
    end
  end
end
