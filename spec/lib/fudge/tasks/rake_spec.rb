require 'spec_helper'

describe Fudge::Tasks::Rake do
  it { should be_registered_as :rake }
  it { should be_a Fudge::Tasks::Shell }

  describe :run do
    it "should be rake by default" do
      subject.should run_command 'rake '
    end

    it "should add any arguments given" do
      described_class.new('db:migrate').should run_command 'rake db:migrate'
    end
  end
end
