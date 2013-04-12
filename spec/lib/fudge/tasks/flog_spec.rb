require 'spec_helper'

describe Fudge::Tasks::Flog do
  it { should be_registered_as :flog }

  it_should_behave_like 'bundle aware'


  let(:output_good) do
    <<-EOF
  378.6: flog total
    5.0: flog/method average

   10.0: Fudge::Tasks::Shell#check_for_output ./lib/fudge/tasks/shell.rb:36
    0.0: Fudge::Runner#run_build          ./lib/fudge/runner.rb:11
    0.0: Fudge::Tasks#none
EOF
  end

  let(:output_bad_average_good_max) do
    <<-EOF
  378.6: flog total
    6.0: flog/method average

   10.0: Fudge::Tasks::Shell#check_for_output ./lib/fudge/tasks/shell.rb:36
    9.0: Fudge::Runner#run_build          ./lib/fudge/runner.rb:11
    9.0: Fudge::Tasks#none
EOF
  end

  let(:output_good_average_bad_max) do
    <<-EOF
  378.6: flog total
    5.0: flog/method average

   22.9: Fudge::Tasks::Shell#check_for_output ./lib/fudge/tasks/shell.rb:36
   19.0: Fudge::Runner#run_build          ./lib/fudge/runner.rb:11
   19.0: Fudge::Tasks#none
EOF
  end

  describe :run do
    it "runs flog on the codebase" do
      subject.should run_command "flog `find . | grep -e '\\.rb$'`"
    end

    context 'with :exclude => pattern' do
      subject {described_class.new :exclude => 'spec/'}

      it "filters out the pattern" do
        with_pattern = "flog `find . | grep -e '\\.rb$' | grep -v -e 'spec/'`"
        subject.should run_command with_pattern
      end
    end

    context 'with :methods => true' do
      subject {described_class.new :methods => true}

      it "runs with methods only flag" do
        with_pattern = "flog -m `find . | grep -e '\\.rb$'`"
        subject.should run_command with_pattern
      end
    end

    it { should_not succeed_with_output output_good_average_bad_max }
    it { should_not succeed_with_output output_bad_average_good_max }
    it { should succeed_with_output output_good }

    context 'when :max score is supplied' do
      it 'fails when score is higher than max' do
        task = described_class.new :max => 9.9
        task.should_not succeed_with_output output_good

        task = described_class.new :max => 10.0
        task.should succeed_with_output output_good
      end
    end

    context 'when :average score is supplied' do
      it 'fails when average is higher than :average' do
        task = described_class.new :average => 4.9
        task.should_not succeed_with_output output_good

        task = described_class.new :average => 5.0
        task.should succeed_with_output output_good
      end
    end
  end
end
