require 'spec_helper'

describe Fudge::FudgeFile::Tasks::Yard do
  subject { described_class.new }

  it { should be_registered_as :yard }

  describe :run do
    it "should run yard" do
      subject.should_receive('`').with('yard')

      subject.run
    end

    it "should accept extra arguments as arguments" do
      subject = described_class.new :arguments => '-r YardREADME.md'

      subject.should_receive('`').with('yard -r YardREADME.md')

      subject.run
    end

    describe "coverage checking" do
      it "should succeed if coverage is greater than given" do
        subject = described_class.new(:coverage => 90)

        subject.should_receive('`').and_return('100.00% documented')

        subject.run.should be_true
      end

      it "should fail if coverage is less than given" do
        subject = described_class.new(:coverage => 90)

        subject.should_receive('`').and_return('80.45% documented')

        subject.run.should be_false
      end

      it "should pass if coverage is the same as given" do
        subject = described_class.new(:coverage => 100)

        subject.should_receive('`').and_return('100.00% documented')

        subject.run.should be_true
      end

      it "should fail if no coverage output was found" do
        subject = described_class.new(:coverage => 100)

        subject.should_receive('`').and_return('')

        subject.run.should be_false
      end
    end
  end
end
